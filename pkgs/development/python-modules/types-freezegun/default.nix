{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-freezegun";
  version = "1.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kxiv0yjbbvp1zx694ir149b26kjzvb6600fh397v32b8jvs8w2w";
  };

  # Module doesn't have tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for freezegun";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
