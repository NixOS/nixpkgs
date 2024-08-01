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
  version = "1.1.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Erotemic";
    repo = "xdoctest";
    rev = "refs/tags/v${version}";
    hash = "sha256-L/RtD/e0ubW3j4623HQGfowXQYZjl7dDfwwbfxm3ll8=";
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
