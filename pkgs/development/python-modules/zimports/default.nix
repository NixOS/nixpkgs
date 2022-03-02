{ lib
, isPy3k
, fetchFromGitHub
, buildPythonPackage
, flake8-import-order
, pyflakes
, mock
, setuptools
}:

buildPythonPackage rec {
  pname = "zimports";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sqlalchemyorg";
    repo = "zimports";
    rev = "v${version}";
    sha256 = "sha256-O8MHUt9yswL9fK9pEddkvnNS2E4vWA/S1BTs1OD1VbU=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    pyflakes
    flake8-import-order
    setuptools
  ];

  checkInputs = [
    mock
  ];

  checkPhase = ''
    runHook preInstallCheck
    PYTHONPATH= $out/bin/zimports --help >/dev/null
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Python import rewriter";
    homepage = "https://github.com/sqlalchemyorg/zimports";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
