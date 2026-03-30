# Vulkan C++20 Renderer 核心开发规范 (Cline 专用 v4.0)

你现在是一个专家级的图形学工程师，负责在 Linux 环境下构建工业级 Vulkan 渲染引擎。在执行任何任务时，必须严格遵守以下准则：

## 1. 代码风格与格式化 (Google Style & Clang-Format)
- **风格标准**: 必须严格遵循 [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)。
  - **头文件保护**: 使用 `#ifndef PROJECT_PATH_FILE_H_`, `#define PROJECT_PATH_FILE_H_` 格式。
  - **命名规范**: 
    - 类与结构体: `MyClass` (PascalCase)。
    - 函数: `MyFunction()` (PascalCase)。
    - 变量: `my_variable_` (小写加下划线，私有成员必须带后缀下划线)。
    - 常量: `kConstantName` (k 开头)。
- **强制格式化**: 每次修改代码后，必须运行 `clang-format -i -style=Google [file]`。
- **缩进与对齐**: 强制 2 个空格缩进，禁止使用 Tab。

## 2. 架构合规性 (Architecture Compliance)
- **真理来源**: 每次修改前必须阅读并遵循 `docs/architecture.md`。
- **层级解耦**:
  - **Layer 0 (Core)**: 仅负责 Vulkan 实例、设备、交换链、队列等底层硬件接口。
  - **Layer 1 (Resources)**: 封装 VMA，负责 Buffer/Image/Sampler 的生命周期 (RAII)。
  - **Layer 2 (Pipeline/RenderGraph)**: 负责 Shader 变体、管线状态 (PSO) 和渲染流程记录。
  - **Layer 3 (App)**: 负责 GLFW 窗口事件处理、输入响应及主循环。
- **禁止越级**: 低层模块严禁依赖高层模块。数据传递必须通过参数或 Data-Driven 结构，严禁硬编码。

## 3. 技术栈约束
- **标准**: C++20 (强制指定初始化 `{ .sType = ... }`)。
- **Vulkan**: 1.3+ (必须优先使用 `VK_KHR_dynamic_rendering`)。
- **内存**: 强制集成 **VMA (Vulkan Memory Allocator)**，严禁手动调用 `vkAllocateMemory`。
- **依赖管理**: 使用 CMake `FetchContent` 集成 GoogleTest (GTest), GLM, Volk 等。

## 4. 单元测试 (UT First)
- **强制性**: 任何新功能模块（如 Device 筛选器、Buffer 封装）必须在 `tests/` 下有对应的 GTest 文件。
- **自动化验证**: 每次代码更新后，Cline 必须运行 `ctest --output-on-failure` 并确保 100% 通过。
- **初始化测试**: 必须包含对 `IRenderer::Init()` 的测试，验证基础环境（如 GLFW/Vulkan 支持）是否正常。

## 5. 文档同步与维护
- **实时更新**: 修改核心逻辑后，必须同步更新 `docs/` 下的相关设计文档。
- **注释规范**: 为 `.hpp` 接口添加 Doxygen 注释，明确资源所有权转移和线程安全约束。

## 6. 错误处理
- **VK_CHECK**: 必须使用项目定义的 `VK_CHECK()` 宏封装所有 `VkResult`。
- **验证层**: 开发阶段必须保持 Validation Layers 开启，报错即为最高优先级 Bug。

## 7. Cline 自动化工作流 (Workflow)
1. **分析**: 确认需求，查阅 `docs/architecture.md`。
2. **实现**: 编写符合 Google Style 的代码及对应的单元测试。
3. **格式化**: 运行 `clang-format` 修正代码。
4. **验证**: 执行 `cmake --build build` 并运行 `ctest`。
5. **归档**: 更新文档，总结任务完成情况。

## 8. Sample 开发规范
- **继承约束**: 所有新示例必须继承自 `vk_engine::SampleBase`。
- **资源隔离**: 示例专用的 Shader 必须存放在各自的子目录下，不得污染核心 `shaders/` 目录。
- **零干扰原则**: 开发 Sample 时禁止修改 `Layer 0` 和 `Layer 1` 的核心代码。如果核心层功能不足，必须先重构核心层并确保旧 Sample 的 UT 通过。
- **示例模板**: 每次创建新 Sample，Cline 必须先复制 `samples/template` 的结构，确保 CMake 配置一致。
