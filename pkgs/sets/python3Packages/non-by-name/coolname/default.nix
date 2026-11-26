{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coolname";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexanderlukanin13";
    repo = "coolname";
    tag = version;
    hash = "sha256-6po9SJGVvOEoSSBtRsbbFE59APFrSkF7uQqaJA8ejoU=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "coolname"
  ];

  # Tests require coolname.data to be packaged
  doCheck = false;

  meta = {
    description = "Random Name and Slug Generator";
    homepage = "https://github.com/alexanderlukanin13/coolname";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
