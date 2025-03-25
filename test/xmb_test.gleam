import gleam/string_tree
import gleeunit
import gleeunit/should
import xmb.{text, x}

pub fn main() {
  gleeunit.main()
}

pub fn hello_joe_test() {
  x("greeting", [], [text("Hello Joe!")])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<greeting>Hello Joe!</greeting>")
}

pub fn empty_tags_test() {
  x("greeting", [], [])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<greeting />")
}

pub fn attributes_tags_test() {
  x("greeting", [#("important", "true"), #("really", "yes")], [])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<greeting important=\"true\" really=\"yes\" />")
}

pub fn documents_test() {
  [
    x("wibble", [], [text("the wibble!")]),
    x("wibble", [], [text("another wibble!")]),
    x("wibble", [], [text("yes, you guessed, another wibble")]),
  ]
  |> xmb.render
  |> string_tree.to_string
  |> should.equal(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><wibble>the wibble!</wibble><wibble>another wibble!</wibble><wibble>yes, you guessed, another wibble</wibble>",
  )
}

pub fn escaping_test() {
  x("stuff", [], [text("<script>alert('&');</script>")])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<stuff>&lt;script&gt;alert('&amp;');&lt;/script&gt;</stuff>")
}

pub fn cdata_test() {
  x("stuff", [], [xmb.cdata("<script>alert('&');</script>")])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<stuff><![CDATA[<script>alert('&');</script>]]></stuff>")
}

pub fn cdata_escaping_test() {
  x("stuff", [], [xmb.cdata(" ]]> ")])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<stuff><![CDATA[ ]]]]><!CDATA[> ]]></stuff>")
}

pub fn nothing_test() {
  x("stuff", [], [xmb.text("before "), xmb.nothing(), xmb.text(" after")])
  |> xmb.render_fragment
  |> string_tree.to_string
  |> should.equal("<stuff>before  after</stuff>")
}
