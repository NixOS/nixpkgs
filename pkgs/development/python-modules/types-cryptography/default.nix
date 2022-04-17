{ lib
, buildPythonPackage
, fetchPypi
, types-enum34
, types-ipaddress
}:

buildPythonPackage rec {
  pname = "types-cryptography";
  version = "3.3.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-u+9bZpcllvPNYbMJFxn8k14IHzu6h+zqVhvA27Fnh1M=";
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
