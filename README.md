# Extensible Markup Builder

[![Package Version](https://img.shields.io/hexpm/v/htmb)](https://hex.pm/packages/htmb)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/htmb/)

A tiny XML builder for Gleam.

```gleam
let html = 
  x("greeting", [], [text("Hello, Joe!")])
  |> render
  |> string_builder.to_string
assert html == "<greeting>Hello, Joe!</greeting>"
```

This package doesn't do much. If you'd like more features, check out these
alternatives:

- [xmleam](https://hex.pm/packages/xmleam)


## Installation

```sh
gleam add xmb
```

The documentation can be found at <https://hexdocs.pm/xmb>.
