{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7bead8cf6210eadf9cecf356e17af794f57c0939a3d420a00d87ea652f87b49";
  };

  meta = with lib; {
    homepage = "https://github.com/ifduyue/python-xxhash";
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
