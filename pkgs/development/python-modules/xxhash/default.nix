{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "xxhash";
  version = "3.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A3nWzx/5h81CFgmiZM4CXnTzRuPhRd0QbAzC4+w/mak=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "xxhash"
  ];

  meta = with lib; {
    description = "Python Binding for xxHash";
    homepage = "https://github.com/ifduyue/python-xxhash";
    changelog = "https://github.com/ifduyue/python-xxhash/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
