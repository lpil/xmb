# Extensible Markup Builder

[![Package Version](https://img.shields.io/hexpm/v/xmb)](https://hex.pm/packages/xmb)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/xmb/)

A tiny XML builder for Gleam.

```gleam
import xmb.{text, x}
import gleam/io
import gleam/string_builder

pub fn main() {
  x("greeting", [], [text("Hello, Joe!")])
  |> xmb.render
  |> string_builder.to_string
  |> io.println
}
```
```xml
<?xml version=\"1.0\" encoding=\"UTF-8\"?><greeting>Hello, Joe!</greeting>
```

This package doesn't do much. If you'd like more features, check out these
alternatives:

- [xmleam](https://hex.pm/packages/xmleam)


## Installation

```sh
gleam add xmb
```

The documentation can be found at <https://hexdocs.pm/xmb>.
