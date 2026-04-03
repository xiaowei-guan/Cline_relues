import 'package:flutter/material.dart';
import 'package:flutter_gen_ui/flutter_gen_ui.dart'; // 确保引入了插件

// 1. 准备 Catalog
final myCatalog = WidgetCatalog([
  CatalogItem(
    name: 'Text', // 必须完全匹配 JSON 中的 "component": "Text"
    builder: (context, data) {
      // data 包含了 JSON 中该组件的所有属性（text, variant 等）
      final String content = data['text'] ?? '';
      final String variant = data['variant'] ?? 'body';

      // 根据 variant 映射样式
      TextStyle style;
      switch (variant) {
        case 'h1':
          style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
          break;
        default:
          style = const TextStyle(fontSize: 14);
      }

      return Text(content, style: style);
    },
  ),
  
  // 如果以后有 Container 或 Button，继续在这里添加 CatalogItem
]);
