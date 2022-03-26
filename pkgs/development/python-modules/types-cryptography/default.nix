{ lib
, buildPythonPackage
, fetchPypi
, types-enum34
, types-ipaddress
}:

buildPythonPackage rec {
  pname = "types-cryptography";
  version = "3.3.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RI/q+a4xImFJvGvOHPj/9U2mYe8Eg398DDFoKYhcNig=";
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
