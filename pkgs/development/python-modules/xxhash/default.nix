{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MLLZeq8R+xIgI/a0TruXxpVengDXRhqWQVygMLXOucc=";
  };

  meta = with lib; {
    homepage = "https://github.com/ifduyue/python-xxhash";
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
