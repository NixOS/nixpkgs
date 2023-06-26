{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MobeeelKkU5KFIFP/+Ny0ktzTnhKzX+fpzTuODrfjG0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # requires network access

  pythonImportsCheck = [
    "ytmusicapi"
  ];

  meta = with lib; {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    changelog = "https://github.com/sigma67/ytmusicapi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
