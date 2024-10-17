{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xdoctest";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Erotemic";
    repo = "xdoctest";
    rev = "refs/tags/v${version}";
    hash = "sha256-1c3wnQ30J2OfnBffzGfPPt9St8VpLGmFGbifzbw+cOc=";
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
