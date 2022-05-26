{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "57.4.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ml2Nt+7jn2f3i38ABoPMgdZRMABg9n5ukwWOF8aVGpo=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
