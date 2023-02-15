{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools-scm
, click
, logzero
, mypy
, flake8
, pytest-reraise
}:

buildPythonPackage rec {
  pname = "sqlite_backup";
  version = "0.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "seanbreckenridge";
    repo = pname;
    rev = "2e12f471676bc43dcc8bff68f579f3c25cfed4d9";
    hash = "sha256-BlH0tCriieR1vwmBA+MFVkf6PmGsPXt6G8aIj7Y1SsU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    logzero
    click
  ];

  checkInputs = [
    pytestCheckHook
    flake8
    mypy
    pytest-reraise
  ];

  doCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "";
    homepage = "";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
