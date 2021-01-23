{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb7c6a6f7d62350b9f5539045da54422975630e34dd9069584cc776b9917115f";
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
