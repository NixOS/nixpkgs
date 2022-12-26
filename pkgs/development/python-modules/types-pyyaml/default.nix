{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.12.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-PyYAML";
    inherit version;
    sha256 = "sha256-aECBmHHJLe6+aiBn+4AMEbigY2MutOPnVZFOerNgToM=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "yaml-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
