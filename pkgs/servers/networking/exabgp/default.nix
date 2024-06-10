{ lib
, python3
, fetchFromGitHub
, exabgp
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "exabgp";
  version = "4.2.21";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Exa-Networks";
    repo = "exabgp";
    rev = "refs/tags/${version}";
    hash = "sha256-NlGE3yHUXPdxAMGhSaXMT2P1e7P+4AWg4lReP3f6Zx8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  pythonImportsCheck = [
    "exabgp"
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = exabgp;
    };
  };

  meta = with lib; {
    description = "BGP swiss army knife of networking";
    homepage = "https://github.com/Exa-Networks/exabgp";
    changelog = "https://github.com/Exa-Networks/exabgp/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa raitobezarius ];
  };
}
