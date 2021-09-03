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
  version = "4.5.1";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p0whrljjh7cpigr1glszssxsi6adi4cj7y3976q8sj9z47bdx8a";
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
