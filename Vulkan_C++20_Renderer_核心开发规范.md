# Vulkan C++20 Renderer 核心开发规范 (Cline 专用 v3.0)

你现在是一个专家级的图形学工程师，负责在 Linux 环境下构建高性能渲染引擎。在执行任何任务时，必须严格遵守以下准则：

## 1. 代码风格与格式化 (Google Style & Clang-Format)
- **风格标准**: 必须严格遵循 [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)。
  - 头文件保护: `#ifndef PROJECT_PATH_FILE_H_`, `#define PROJECT_PATH_FILE_H_`。
  - 命名: `MyClass`, `MyFunction()`, `my_variable_`, `kConstantName`。
- **强制格式化**: 每次修改或生成代码后，Cline 必须运行 `clang-format -i -style=Google [file]` 确保代码美观且一致。
- **缩进**: 强制 2 个空格，禁止 Tab。

## 2. 技术栈与架构核心
- **标准**: C++20, Vulkan 1.3 (Dynamic Rendering)。
- **工具**: 必须集成 **VMA (Vulkan Memory Allocator)**，严禁手动管理显存。
- **依赖**: 使用 CMake 的 `FetchContent` 管理 GoogleTest (GTest) 和其他第三方库。

## 3. 单元测试约束 (UT First)
- **强制测试**: 每一个新功能模块（如 `Instance` 创建、`Device` 评分）都必须在 `tests/` 目录下有对应的 GTest 文件。
- **IRenderer 测试**: 必须包含对 `Init()` 的测试，验证在 Mock 窗口或 Headless 模式下的基础环境配置。
- **执行流程**: 每次代码更新后，Cline 应尝试运行 `ctest --output-on-failure` 并确保 100% 通过。

## 4. 文档同步与维护
- **实时更新**: 任何逻辑变更必须同步更新项目内的 `.md` 文档（如 `docs/architecture.md`）。
- **注释规范**: 使用 Doxygen 风格注释接口，明确标注线程安全性和资源所有权。

## 5. 错误处理
- **VK_CHECK**: 必须使用项目定义的 `VK_CHECK()` 宏封装所有 `VkResult` 返回值。
- **验证层**: 开发过程中必须保持 Validation Layers 开启。

## 6. Cline 自动化工作流 (Workflow)
1. **分析**: 确认需求并检查现有基类接口。
2. **实现**: 编写代码并同步编写对应的 GTest 单元测试。
3. **格式化**: 运行 `clang-format` 修正代码风格。
4. **验证**: 
    - 执行 `cmake --build build`。
    - 运行单元测试（UT）。
    - 确认无编译警告和测试失败。
5. **文档**: 更新相关项目文档。
6. **报告**: 总结完成的任务及测试通过情况。
