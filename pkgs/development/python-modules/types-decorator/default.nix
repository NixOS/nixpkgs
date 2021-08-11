{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pmcc8xpsmij4174ky81vp811yxgic2lj1dfj2fa0ii87nlcfwhp";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "decorator-stubs" ];

  meta = with lib; {
    description = "Typing stubs for decorator";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
