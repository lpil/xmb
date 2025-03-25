//// # Extensible Markup Builder
//// 
//// A tiny XML builder for Gleam.
//// 
//// ```gleam
//// let html = 
////   x("greeting", [], [text("Hello, Joe!")])
////   |> render
////   |> string_tree.to_string
//// assert html == "<greeting>Hello, Joe!</greeting>"
//// ```
//// 
//// This package doesn't do much. If you'd like more features, check out these
//// alternatives:
//// 
//// - [xmleam](https://hex.pm/packages/xmleam)
//// 

import gleam/list
import gleam/string
import gleam/string_tree.{type StringTree}

pub type Xml

/// Create a XML element with attributes and children.
pub fn x(
  tag: String,
  attributes: List(#(String, String)),
  children: List(Xml),
) -> Xml {
  let opening = "<" <> tag
  let opening = list.fold(attributes, opening, attribute)

  case children {
    [] -> string_tree.from_string(opening <> " />")

    _ ->
      { opening <> ">" }
      |> string_tree.from_string
      |> list.fold(children, _, child)
      |> string_tree.append("</" <> tag <> ">")
  }
  |> dangerous_unescaped_fragment
}

/// Create a XML text node.
pub fn text(content: String) -> Xml {
  content
  |> do_escape("", _)
  |> string_tree.from_string
  |> dangerous_unescaped_fragment
}

/// Create a XML text node as CDATA rather than escaping XML entities. This is
/// often easier to read and will render slightly faster.
pub fn cdata(content: String) -> Xml {
  let content = string.replace(content, "]]>", "]]]]><!CDATA[>")
  string_tree.from_string("<![CDATA[" <> content <> "]]>")
  |> dangerous_unescaped_fragment
}

/// Create a text node of nothing at all!
pub fn nothing() -> Xml {
  string_tree.new()
  |> dangerous_unescaped_fragment
}

pub fn escape(content: String) -> String {
  do_escape("", content)
}

fn do_escape(escaped: String, content: String) -> String {
  case string.pop_grapheme(content) {
    Ok(#("<", xs)) -> do_escape(escaped <> "&lt;", xs)
    Ok(#(">", xs)) -> do_escape(escaped <> "&gt;", xs)
    Ok(#("&", xs)) -> do_escape(escaped <> "&amp;", xs)
    Ok(#(x, xs)) -> do_escape(escaped <> x, xs)
    Error(_) -> escaped <> content
  }
}

pub fn render(xml: List(Xml)) -> StringTree {
  xml
  |> list.map(render_fragment)
  |> string_tree.concat
  |> string_tree.prepend("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
}

fn attribute(content: String, attribute: #(String, String)) -> String {
  content <> " " <> attribute.0 <> "=\"" <> attribute.1 <> "\""
}

fn child(siblings: StringTree, child: Xml) -> StringTree {
  string_tree.append_tree(siblings, render_fragment(child))
}

@external(erlang, "xmb_ffi", "identity")
@external(javascript, "./xmb_ffi.mjs", "identity")
pub fn dangerous_unescaped_fragment(s: StringTree) -> Xml

@external(erlang, "xmb_ffi", "identity")
@external(javascript, "./xmb_ffi.mjs", "identity")
pub fn render_fragment(element: Xml) -> StringTree
