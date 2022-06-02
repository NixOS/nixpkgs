{ lib
, buildPythonPackage
, fetchPypi
, types-cryptography
}:

buildPythonPackage rec {
  pname = "types-paramiko";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q2iT1fzl7QaWTWGTntanFoqxSVKUWpCZWmKKXoKl4WE=";
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
