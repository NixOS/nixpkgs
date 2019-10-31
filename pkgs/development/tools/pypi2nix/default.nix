{ python3
}:
with python3;

pkgs.buildPythonApplication rec {
  pname = "pypi2nix";
  version = "2.0.0";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0w9z07kdnfs96230jag8xgz4wx337bb3q3bvqxn3r31x8fsmz6rr";
  };
  checkInputs = with pkgs; [ pytest ];
  propagatedBuildInputs = with pkgs; [
    attrs
    click
    jinja2
    nix-prefetch-github
    packaging
    parsley
    setuptools
    toml
  ];
  checkPhase = "${python3.interpreter} -m pytest unittests -m 'not nix'";
}
