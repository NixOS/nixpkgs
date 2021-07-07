{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "022q31fgiyq6zfjv4pbpg10hh9m7x91wqfc6bdyin50hf980q3gf";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "requests-stubs" ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
