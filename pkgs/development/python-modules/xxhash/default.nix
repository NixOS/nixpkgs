{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58ca818554c1476fa1456f6cd4b87002e2294f09baf0f81e5a2a4968e62c423c";
  };

  meta = with lib; {
    homepage = "https://github.com/ifduyue/python-xxhash";
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
