#!/usr/bin/env bash

# --- 脚本说明 ---
#
# 功能: 测试服务器到中国大陆主要运营商（电信, 联通, 移动）节点的网络速度。
# 作者: [xxntmctx]
# Github: [https://github.com/xxntmctx/Safe-MultiNetwork-Speedtest]
#
# 安全改进:
# 1. 使用 Ookla 官方下载链接，并强制使用 HTTPS 进行安全下载。
# 2. 移除了不安全的 "--no-check-certificate" 选项。
# 3. 优化了架构检测，使其更具可读性，并增加了对 ARM 架构的支持。
# 4. 增加了稳健的错误处理和自动清理机制。
#
# --- 颜色定义 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
PLAIN='\033[0m'

# --- 核心函数 ---

# 确保脚本以 root 用户权限运行
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}错误: 请使用 root 用户权限运行此脚本。${PLAIN}"
        exit 1
    fi
}

# 检测系统发行版
check_system() {
    if [ -f /etc/redhat-release ]; then
        release="centos"
        package_manager="yum"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
        package_manager="apt-get"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
        package_manager="apt"
    else
        echo -e "${RED}错误: 无法识别的操作系统。脚本将尝试使用 apt 或 yum。${PLAIN}"
        if command -v apt &> /dev/null; then
            package_manager="apt"
        elif command -v yum &> /dev/null; then
            package_manager="yum"
        else
            echo -e "${RED}致命错误: 未找到 apt 或 yum。无法自动安装依赖。${PLAIN}"
            exit 1
        fi
    fi
}

# 检查并安装指定的软件包
install_package() {
    if ! command -v "$1" &> /dev/null; then
        echo "正在安装依赖: $1 ..."
        # 更新软件源并安装，隐藏不必要的输出
        $package_manager update > /dev/null 2>&1
        $package_manager install -y "$1" > /dev/null 2>&1
        if ! command -v "$1" &> /dev/null; then
            echo -e "${RED}错误: $1 安装失败。请手动安装后重试。${PLAIN}"
            exit 1
        fi
    fi
}

# 下载并准备 Speedtest CLI 工具
setup_speedtest() {
    if [ ! -f "./speedtest-cli/speedtest" ]; then
        echo "正在从官方源下载并安装 Speedtest CLI..."
        arch=$(uname -m)
        case "$arch" in
            "x86_64") arch_suffix="x86_64" ;;
            "aarch64") arch_suffix="aarch64" ;;
            "armv7l" | "armv8l") arch_suffix="armhf" ;;
            *) echo -e "${RED}错误: 不支持的系统架构: $arch ${PLAIN}"; exit 1 ;;
        esac

        local download_url="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${arch_suffix}.tgz"
        
        if ! curl -L -# -o speedtest.tgz "$download_url"; then
            echo -e "${RED}错误: Speedtest CLI 下载失败。请检查网络或官方链接。${PLAIN}"
            exit 1
        fi

        mkdir -p speedtest-cli
        tar -zxf speedtest.tgz -C ./speedtest-cli/
        chmod +x ./speedtest-cli/speedtest
    fi
}

# 执行单次测速
speed_test() {
    local nodeID=$1
    local nodeLocation=$2
    local nodeISP=$3
    local speedLog="./speedtest.log"

    ./speedtest-cli/speedtest -p no -s "$nodeID" --accept-license --accept-gdpr > "$speedLog" 2>&1

    if grep -q 'Upload' "$speedLog"; then
        local download=$(grep 'Download' "$speedLog" | awk '{print $3}')
        local upload=$(grep 'Upload' "$speedLog" | awk '{print $3}')
        local latency=$(grep 'Latency' "$speedLog" | awk '{print $2}')
        
        printf "${RED}%-6s${YELLOW}%s | ${GREEN}%-18s${CYAN}↑ %-10s${BLUE}↓ %-10s${PURPLE}%-8s${PLAIN}\n" \
            "$nodeID" "$nodeISP" "$nodeLocation" "$upload Mbps" "$download Mbps" "$latency ms"
    else
        printf "${RED}%-6s${YELLOW}%s | ${GREEN}%-18s${RED}%s${PLAIN}\n" \
            "$nodeID" "$nodeISP" "$nodeLocation" "测试失败"
    fi
}

# 清理函数
cleanup() {
    # echo "正在清理临时文件..."
    rm -rf speedtest.tgz speedtest-cli speedtest.log
}

# --- 脚本执行流程 ---
main() {
    trap cleanup EXIT
    check_root
    check_system
    install_package "curl"
    install_package "tar"
    setup_speedtest

    clear
    echo "==================================================================="
    echo "          安全版三网测速脚本 (作者: [你的名字])"
    echo "==================================================================="
    
    echo -e "\n${CYAN}--- 开始测试电信节点 ---${PLAIN}"
    echo "ID    运营商 | 节点位置            上传速度      下载速度      延迟"
    speed_test '27377' '北京 5G' '电信'
    speed_test '3633'  '上海' '电信'
    speed_test '27594' '广州 5G' '电信'

    echo -e "\n${CYAN}--- 开始测试联通节点 ---${PLAIN}"
    echo "ID    运营商 | 节点位置            上传速度      下载速度      延迟"
    speed_test '5145'  '北京' '联通'
    speed_test '24447' '上海 5G' '联通'
    speed_test '26678' '广州 5G' '联通'

    echo -e "\n${CYAN}--- 开始测试移动节点 ---${PLAIN}"
    echo "ID    运营商 | 节点位置            上传速度      下载速度      延迟"
    speed_test '25858' '北京' '移动'
    speed_test '25637' '上海 5G' '移动'
    speed_test '6611'  '广州' '移动'
    
    echo "==================================================================="
    echo "  测试完成！脚本将在退出时自动清理临时文件。"
    echo "==================================================================="
}

# 运行主函数
main
