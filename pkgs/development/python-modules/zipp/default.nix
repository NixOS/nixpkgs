{ lib
, buildPythonPackage
, fetchPypi
, func-timeout
, jaraco_itertools
, pythonOlder
, setuptools-scm
}:

let zipp = buildPythonPackage rec {
  pname = "zipp";
  version = "3.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o8rIE9QJk1lrOeqek6GOiiB21cN4uLyI7DKrJk4ErQI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Prevent infinite recursion with pytest
  doCheck = false;

  nativeCheckInputs = [
    func-timeout
    jaraco_itertools
  ];

  pythonImportsCheck = [
    "zipp"
  ];

  passthru.tests = {
    check = zipp.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = "https://github.com/jaraco/zipp";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}; in zipp
