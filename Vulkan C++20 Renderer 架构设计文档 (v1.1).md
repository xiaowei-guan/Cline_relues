# Vulkan C++20 Renderer 架构设计文档 (v1.1)

本文件定义了渲染引擎的分层架构、模块边界及多示例（Multi-Sample）扩展机制。所有代码提交必须符合此文档定义的设计模式。

---

## 1. 核心设计原则
* **Data-Driven (数据驱动)**: 渲染状态与资源绑定通过配置对象传递，严禁在底层硬编码业务逻辑。
* **RAII 资源管理**: 强制利用 C++20 智能指针与 VMA (Vulkan Memory Allocator) 管理所有 GPU 资源生命周期。
* **Layered Decoupling (分层解耦)**: 遵循“依赖倒置”原则，高层模块感知底层接口，底层模块对高层逻辑透明。
* **Modern Pipeline**: 默认使用 `VK_KHR_dynamic_rendering` (Vulkan 1.3+) 以简化 RenderPass 管理。

---

## 2. 系统分层架构

引擎采用严格的四层拓扑结构，并在顶层支持可插拔的 Samples 模块。

| 层次 | 名称 | 职责描述 | 关键组件 |
| :--- | :--- | :--- | :--- |
| **Layer 4** | **Samples** | 具体的渲染示例（如 PBR, Shadows）。继承自 `SampleBase`。 | `samples/` 目录 |
| **Layer 3** | **App Framework** | GLFW 窗口管理、输入处理、示例调度逻辑、主循环。 | `SampleBase`, `AppHost` |
| **Layer 2** | **Renderer 层** | 指令缓冲记录 (Command Recording)、PSO 管理、同步原语封装。 | `PipelineBuilder`, `Sync2` |
| **Layer 1** | **Resource 层** | 基于 VMA 的内存分配、Buffer/Image/Sampler 生命周期管理。 | `VmaAllocator`, `BufferWrapper` |
| **Layer 0** | **Core 层** | Vulkan Instance/Device 创建、硬件评分、队列管理、Volk 加载。 | `DeviceSelector`, `ValidationLayers` |



---

## 3. 详细模块说明

### 3.1 Layer 0 & 1: 基础设施 (The Foundation)
* **DeviceContext**: 负责物理设备的自动化筛选。优先选择支持 `Discrete GPU` 且具备 `Dynamic Rendering` 特性的设备。
* **ResourceManager**: 
    * 集成 **VMA**。
    * 所有资源创建必须返回 `std::unique_ptr<T, Deleter>`，确保在对象析构时自动触发 `vmaDestroyBuffer` 等操作。

### 3.2 Layer 2 & 3: 渲染框架 (The Framework)
* **SampleBase (基类)**: 定义了示例的标准生命周期。
    * `virtual void OnSetup()`: 初始化资源。
    * `virtual void OnUpdate(float delta)`: 逻辑更新。
    * `virtual void OnRender(VkCommandBuffer cmd)`: 指令记录。
* **AppHost**: 驱动 GLFW 窗口并调用当前活跃 Sample 的钩子函数。

---

## 4. 多示例 (Multi-Sample) 组织规范

### 4.1 目录结构
```text
├── src/
│   ├── core/           # Layer 0 实现
│   ├── resources/      # Layer 1 实现
│   ├── renderer/       # Layer 2 实现
│   └── framework/      # Layer 3 (SampleBase, AppHost)
├── samples/
│   ├── 01_clear_screen/  # 仅测试初始化与清屏
│   ├── 02_hello_triangle/# 基础几何体渲染
│   └── 03_bindless_pbr/  # 高级无绑定渲染示例
├── tests/              # 各层级的 GTest 单元测试
└── docs/               # 架构与 API 文档
