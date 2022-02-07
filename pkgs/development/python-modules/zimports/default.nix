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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sqlalchemyorg";
    repo = "zimports";
    rev = "v${version}";
    sha256 = "11mg7j7xiypv9hki4qbnp9jsgwgfdrgdzfqyrzk5x0s4hycgi4q0";
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
