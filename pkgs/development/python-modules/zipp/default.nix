{ lib
, buildPythonPackage
, fetchPypi
, func-timeout
, jaraco-itertools
, pythonOlder
, setuptools-scm
}:

let zipp = buildPythonPackage rec {
  pname = "zipp";
  version = "3.17.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hOZKHCjPfpHtIHi7jMjCWcsZt2lCCWyNe4SUdpDKuvA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Prevent infinite recursion with pytest
  doCheck = false;

  nativeCheckInputs = [
    func-timeout
    jaraco-itertools
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
    maintainers = with maintainers; [ ];
  };
}; in zipp
