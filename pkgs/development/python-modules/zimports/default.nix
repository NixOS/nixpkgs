{ lib
, isPy3k
, fetchFromGitHub
, buildPythonPackage
, flake8-import-order
, pyflakes
, tomli
, setuptools
, mock
}:

buildPythonPackage rec {
  pname = "zimports";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sqlalchemyorg";
    repo = "zimports";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qm5mA8pCSLbkupGBo+ppHSW6uy1j/FfV3idvGQGhjqU=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    flake8-import-order
    pyflakes
    setuptools
    tomli
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
