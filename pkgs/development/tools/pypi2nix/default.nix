{ python3
}:
with python3;

pkgs.buildPythonApplication rec {
  pname = "pypi2nix";
  version = "2.0.2";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1kynyarqx49j89nxd7rx8mjncg8hkklscfcr36smham7cvj17nsv";
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
