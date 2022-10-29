{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rCGx4h3G/f7ppXtT9Hd1OdU6hPLhVGo/gC8Vn5lmvcE=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  meta = with lib; {
    homepage = "https://github.com/ifduyue/python-xxhash";
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
