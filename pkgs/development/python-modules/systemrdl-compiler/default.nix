{
  antlr4-python3-runtime,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  gitUpdater,
  lib,
  markdown,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "systemrdl-compiler";
  version = "1.32.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "systemrdl-compiler";
    tag = "v${version}";
    hash = "sha256-1Dx6WxSzGaZxwRzXR/bjfZSU7TsvTYNVN0NaK3qQ7eo=";
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

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "SystemRDL 2.0 language compiler front-end";
    homepage = "https://systemrdl-compiler.readthedocs.io/en/stable/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
