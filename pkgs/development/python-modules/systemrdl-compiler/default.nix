{
  antlr4-python3-runtime,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  lib,
  markdown,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "systemrdl-compiler";
  version = "1.30.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "systemrdl-compiler";
    rev = "v${version}";
    hash = "sha256-9FuKoYHlS0Pe9g5ka5GRSZVYpyfk0/7aqxvdB+EzEfQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    antlr4-python3-runtime
    colorama
    markdown
  ];

  meta = {
    description = "SystemRDL 2.0 language compiler front-end";
    homepage = "https://systemrdl-compiler.readthedocs.io/en/stable/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
