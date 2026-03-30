Task: 实现 Layer 0 核心设备管理与评分系统

实现 DeviceContext: 在 src/core/ 下创建 device_context.cc 和 device_context.h。

Instance 创建:

使用 volk (如果集成了) 或原生加载。

包含 VK_KHR_surface 和 Linux 平台扩展。

必须在 Debug 模式下开启 VK_EXT_debug_utils 验证层。

硬件筛选算法 (The Scorer):

遍历所有 VkPhysicalDevice。

评分逻辑: Discrete GPU (+1000), 支持 geometryShader (+100), 支持 VK_KHR_dynamic_rendering (必须，不支持直接排除)。

选出最高分的设备并创建 VkDevice。

单元测试:

在 tests/core/device_context_test.cc 中编写测试，模拟 Instance 创建流程（可使用 Mock 或 Headless 模式）。

规范执行:

运行 clang-format。

确保 docs/architecture.md 中的 Layer 0 描述与实现保持同步。

运行 ctest 验证。
