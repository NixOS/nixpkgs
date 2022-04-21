{ lib
, buildPythonPackage
, fetchPypi
, types-cryptography
}:

buildPythonPackage rec {
  pname = "types-paramiko";
  version = "2.8.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UhkthDZk73wfh7n+Bpe7u1qPgS5DAWlEz+q+x93spCM=";
  };

  pythonImportsCheck = [
    "paramiko-stubs"
  ];

  propagatedBuildInputs = [ types-cryptography ];

  meta = with lib; {
    description = "Typing stubs for paramiko";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
