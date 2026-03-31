# Vulkan C++20 Renderer 核心开发规范 (Cline 专用 v5.0)

你现在是一个专家级的图形学工程师，负责在 Linux 环境下构建工业级 Vulkan 渲染引擎。在执行任何任务时，必须严格遵守以下准则：

## 1. 任务溯源与记录 (Task Ledger)
- **强制存档**: 每一个独立任务（Task）开始前，必须在 `docs/tasks/` 目录下创建一个以日期和简短描述命名的 Markdown 文件（例如：`2026-03-31_init_device_context.md`）。
- **文档结构**: 
  - **Objective**: 任务目标及涉及的架构层级。
  - **Implementation**: 修改了哪些文件，新增了哪些逻辑。
  - **Decisions**: 记录关键决策（如评分权重、同步方案选择）。
  - **Verification**: 单元测试结果、编译状态及 Validation Layer 检查结果。
- **关联更新**: 任务完成后，必须同步更新 `docs/architecture.md` 以确保文档与代码实时对齐。

## 2. 代码风格与格式化 (Google C++ Style)
- **风格标准**: 严格遵循 [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)。
  - **头文件保护**: 必须使用 `#ifndef PROJECT_PATH_FILE_H_`, `#define PROJECT_PATH_FILE_H_` 风格。
  - **命名规范**: 
    - 类与结构体: `MyClass` (PascalCase)。
    - 函数: `MyFunction()` (PascalCase)。
    - 变量: `my_variable_` (小写加下划线，私有成员必须带后缀下划线)。
    - 常量: `kConstantName` (k 开头)。
- **强制格式化**: 每次修改代码后，必须运行 `clang-format -i -style=Google [file]`。
- **缩进**: 强制 2 个空格，禁止使用 Tab。

## 3. 架构合规性 (Architecture Compliance)
- **真理来源**: 必须遵循 `docs/architecture.md` 定义的四层架构：
  - **Layer 0 (Core)**: Instance, Device, Queue, Validation Layers.
  - **Layer 1 (Resource)**: VMA 封装, Buffer, Image, Sampler (RAII).
  - **Layer 2 (Renderer)**: PipelineBuilder, Sync2, Command Recording.
  - **Layer 3 (App Framework)**: GLFW 绑定, SampleBase, AppHost.
  - **Layer 4 (Samples)**: 具体的渲染示例。
- **禁止越级**: 低层模块严禁依赖高层模块。数据传递必须通过参数或 Data-Driven 结构。

## 4. 技术栈与单元测试 (UT First)
- **标准**: C++20, Vulkan 1.3 (Dynamic Rendering), VMA (Memory)。
- **强制测试**: 每一个功能模块必须在 `tests/` 下有对应的 GoogleTest (GTest) 文件。
- **自动化自检**: 提交前必须运行 `ctest --output-on-failure` 并确保 100% 通过。

## 5. 错误处理
- **VK_CHECK**: 必须使用项目定义的 `VK_CHECK()` 宏封装所有 `VkResult`。
- **验证层**: 开发阶段必须保持 Validation Layers 开启，报错即为最高优先级 Bug。

## 6. Cline 自动化工作流 (Workflow)
1. **Task Logging**: 在 `docs/tasks/` 创建任务记录文件。
2. **Analysis**: 确认需求，查阅 `docs/architecture.md`。
3. **Implementation**: 编写符合 Google Style 的代码及对应的单元测试。
4. **Format**: 运行 `clang-format` 修正代码。
5. **Validation**: 执行 `cmake --build build` 并运行 `ctest`。
6. **Documentation**: 同步更新架构文档，并在任务记录中结项。
