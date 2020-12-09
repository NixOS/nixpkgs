{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5dd700e52ec28c64d43f681ccde76b6436c8f89a332d6c9e22a6b629f28daeb5";
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
