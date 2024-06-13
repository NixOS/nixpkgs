{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xdoctest";
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Erotemic";
    repo = "xdoctest";
    rev = "refs/tags/v${version}";
    hash = "sha256-gKs8HsXm7hskSIw8bhEX1Vo8RbtO0YDjtjBJViz1rCE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "xdoctest" ];

  meta = with lib; {
    description = "Rewrite of Python's builtin doctest module (with pytest plugin integration) with AST instead of REGEX";
    homepage = "https://github.com/Erotemic/xdoctest";
    changelog = "https://github.com/Erotemic/xdoctest/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "xdoctest";
  };
}
