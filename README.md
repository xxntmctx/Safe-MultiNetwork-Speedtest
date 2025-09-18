# 安全版三网测速脚本 (Safe Multi-Network Speedtest Script)

一个安全、快速、方便的 VPS 服务器三网（电信、联通、移动）网络速度测试脚本。

*A safe, fast, and convenient speedtest script for VPS, testing against China's major ISPs (China Telecom, China Unicom, China Mobile).*

---

## ✨ 脚本特点 (Features)

- **安全可靠 (Secure & Reliable)**: 直接从 Speedtest 官方源下载测速程序，全程使用 HTTPS 加密，杜绝中间人攻击风险。
- **纯净无广告 (Clean & Ad-free)**: 脚本内容干净，无任何无关内容或广告。
- **架构自适应 (Auto-Adapting Architecture)**: 自动检测服务器 CPU 架构 (x86_64, aarch64)，下载对应的官方版本。
- **依赖自动装 (Automatic Dependency Installation)**: 自动检测并为 Debian/Ubuntu/CentOS 系统安装所需的 `curl` 和 `tar` 工具。
- **自动清理 (Auto Cleanup)**: 脚本运行结束后会自动删除所有下载的临时文件，保持系统纯净。

## 🚀 一键运行 (Usage)

请在 `root` 用户下执行以下命令即可：

*Please run the following command as the `root` user:*

```bash
bash <(curl -sL https://raw.githubusercontent.com/xxntmctx/Safe-MultiNetwork-Speedtest/main/safe_speedtest.sh)
<img width="708" height="632" alt="image" src="https://github.com/user-attachments/assets/935d32d6-d63b-4556-a5a6-ccd4ce195bac" />
