{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52de08355fd5cfb3ef4533891092bb96229d43c2069703d4aff04fdbedf9c92f";
  };

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ hypothesis ];

  meta = with lib; {
    description = "zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
