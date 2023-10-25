{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  version = "3.2.0";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gv1Hr4lVxdtzD2MK1TrnmM9/rgrLZM67PPlNNcR90Ig=";
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
