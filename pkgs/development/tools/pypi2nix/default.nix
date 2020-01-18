{ python3
}:
with python3;

pkgs.buildPythonApplication rec {
  pname = "pypi2nix";
  version = "2.0.3";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0mja8q5lc0lils6s0v0l35knsj7n7779kw246jfmyvkc3l07j8df";
  };
  propagatedBuildInputs = with pkgs; [
    attrs
    click
    jinja2
    nix-prefetch-github
    packaging
    parsley
    setuptools
    toml
    jsonschema
  ];
}
