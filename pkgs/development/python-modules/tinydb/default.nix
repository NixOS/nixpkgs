{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pycodestyle
, pyyaml
}:

buildPythonPackage rec {
  pname = "tinydb";
  version = "4.7.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cAIo/qdIOIpPt9vPan5oJfKtH2Gmrm03aLuAHpfUfLY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov-append --cov-report term --cov tinydb" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pycodestyle
    pyyaml
  ];

  pythonImportsCheck = [ "tinydb" ];

  meta = with lib; {
    description = "Lightweight document oriented database written in Python";
    homepage = "https://tinydb.readthedocs.org/";
    changelog = "https://tinydb.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ marcus7070 ];
  };
}
