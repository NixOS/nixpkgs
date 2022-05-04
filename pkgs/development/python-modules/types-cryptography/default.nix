{ lib
, buildPythonPackage
, fetchPypi
, types-enum34
, types-ipaddress
}:

buildPythonPackage rec {
  pname = "types-cryptography";
  version = "3.3.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rRucYxWcAJ+GdsfkGk1ZXfuW6MA6/6Lmk+FheQi7QJ4=";
  };

  pythonImportsCheck = [
    "cryptography-stubs"
  ];

  propagatedBuildInputs = [ types-enum34 types-ipaddress ];

  meta = with lib; {
    description = "Typing stubs for cryptography";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
