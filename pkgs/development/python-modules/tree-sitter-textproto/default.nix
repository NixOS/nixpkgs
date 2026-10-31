{
  lib,
  buildPythonPackage,
  setuptools,
  reproto,
}:

buildPythonPackage {
  pname = "tree-sitter-textproto";
  inherit (reproto) src version;
  pyproject = true;
  __structuredAttrs = true;

  # nixpkgs-update: no auto update
  # Built from reproto's source, at its version, with its vendored crates:
  # reproto needs all four of these libraries at exactly its version, so
  # they move with it, in reproto's update.

  sourceRoot = "${reproto.src.name}/reproto/tree-sitter-textproto";

  build-system = [ setuptools ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "tree_sitter_textproto" ];

  meta = {
    description = "Textproto grammar for tree-sitter";
    longDescription = ''
      The protobuf text format grammar prototools uses, modified from
      PorterAtGoogle's tree-sitter-textproto to also parse a bare field
      number as a field name.
    '';
    homepage = "https://github.com/douzebis/prototools";
    license = with lib.licenses; [
      isc
      mit
    ];
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
