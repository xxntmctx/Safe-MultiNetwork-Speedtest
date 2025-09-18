# 安全版三网测速脚本 (Safe Multi-Network Speedtest Script)

一个安全、快速、方便的 VPS 服务器三网（中国电信、中国联通、中国移动）网络速度测试脚本。

*A safe, fast, and convenient speedtest script for VPS, testing against China's major ISPs (China Telecom, China Unicom, China Mobile).*

---

## ✨ 核心优势 (Core Advantages)

* **极致安全 (Enhanced Security)**: 脚本直接从 Speedtest by Ookla 官方源下载测速程序，全程使用 HTTPS 加密传输，杜绝任何中间人攻击的风险，确保来源纯净可靠。
* **智能适配 (Intelligent & Adaptive)**: 自动检测服务器的 CPU 架构（支持 `x86_64` 和 `aarch64`），并下载匹配的官方版本，无需手动选择。
* **纯净无扰 (Clean & Ad-free)**: 脚本内容干净利落，无任何形式的广告或无关内容，提供清爽的使用体验。
* **全自动依赖 (Automatic Dependencies)**: 自动为 Debian/Ubuntu/CentOS 等主流系统检测并安装所需的 `curl` 和 `tar` 工具，免去手动配置的烦恼。
* **环境友好 (Environmentally Friendly)**: 脚本在运行结束后会自动清理所有下载的临时文件，不留任何残余，保持您的系统整洁。

## 🚀 一键启动 (One-Click Start)

仅需以 `root` 用户身份执行以下命令，即可开始测速：

*Please run the following command as the `root` user:*

```bash
bash <(curl -sL https://raw.githubusercontent.com/xxntmctx/Safe-MultiNetwork-Speedtest/main/safe_speedtest.sh)
```

### 测速效果预览 (Speedtest Preview)


![alt text](https://github.com/user-attachments/assets/935d32d6-d63b-4556-a5a6-ccd4ce195bac)

```

```
