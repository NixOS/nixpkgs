{ python3
}:
with python3;

pkgs.buildPythonApplication rec {
  pname = "pypi2nix";
  version = "2.0.1";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "138fwd3cznkfa6w3a5s4fbflh88q26hk4grlmq73dcbk06ykf84k";
  };
  checkInputs = with pkgs; [ pytest ];
  buildInputs = with pkgs; [ setuptools_scm ];
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
