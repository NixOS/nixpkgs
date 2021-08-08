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
  version = "4.5.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rJVJfsPhGTQpE6p0kzN6GDR0r9M71ADa67Oi5jLgeWY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov-append --cov-report term --cov tinydb" ""
  '';

  checkInputs = [
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
