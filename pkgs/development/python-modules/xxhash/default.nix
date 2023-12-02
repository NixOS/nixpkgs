{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  version = "3.4.1";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A3nWzx/5h81CFgmiZM4CXnTzRuPhRd0QbAzC4+w/mak=";
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
