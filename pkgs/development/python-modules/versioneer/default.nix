{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "versioneer";
  version = "0.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nw6aLLXvUhy/0QTUOiCN2RJN+0rM+nLWlODQQwoBQrw=";
  };

  # Couldn't get tests to work because, for instance, they used virtualenv and
  # pip.
  doCheck = false;

  pythonImportsCheck = [
    "versioneer"
  ];

  meta = with lib; {
    description = "Version-string management for VCS-controlled trees";
    homepage = "https://github.com/warner/python-versioneer";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jluttine ];
  };
}
