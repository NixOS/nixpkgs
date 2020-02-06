{
  bash = (builtins.fromJSON (builtins.readFile ./tree-sitter-bash.json));
  c = (builtins.fromJSON (builtins.readFile ./tree-sitter-c.json));
  cpp = (builtins.fromJSON (builtins.readFile ./tree-sitter-cpp.json));
  embedded-template = (builtins.fromJSON (builtins.readFile ./tree-sitter-embedded-template.json));
  go = (builtins.fromJSON (builtins.readFile ./tree-sitter-go.json));
  html = (builtins.fromJSON (builtins.readFile ./tree-sitter-html.json));
  javascript = (builtins.fromJSON (builtins.readFile ./tree-sitter-javascript.json));
  json = (builtins.fromJSON (builtins.readFile ./tree-sitter-json.json));
  python = (builtins.fromJSON (builtins.readFile ./tree-sitter-python.json));
  # wasn’t able to check out with fetchgit
  # ruby = (builtins.fromJSON (builtins.readFile ./tree-sitter-ruby.json));
  rust = (builtins.fromJSON (builtins.readFile ./tree-sitter-rust.json));
  typescript = (builtins.fromJSON (builtins.readFile ./tree-sitter-typescript.json));
}
