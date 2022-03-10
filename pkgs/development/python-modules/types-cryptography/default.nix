{ lib
, buildPythonPackage
, fetchPypi
, types-enum34
, types-ipaddress
}:

buildPythonPackage rec {
  pname = "types-cryptography";
  version = "3.3.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fr70phvg3zc4h41mv48g04x3f20y478y01ji3w1i2mqlxskm657";
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
