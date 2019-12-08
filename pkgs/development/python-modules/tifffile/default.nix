{ lib, fetchPypi, buildPythonPackage, isPy27
, numpy, enum34, futures, pathlib
, pytest
}:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2019.7.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82c5c72de4dc19cc7011e4e8c45492e17121bd02cfa98c015ddd2a83e36f09bc";
  };

  patches = lib.optional isPy27 ./python2-regex-compat.patch;

  # Missing dependencies: imagecodecs, czifile, cmapfile, oiffile, lfdfiles
  # and test data missing from PyPI tarball
  doCheck = false;
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [ numpy ]
    ++ lib.optional isPy27 [ futures enum34 pathlib ];

  meta = with lib; {
    description = "Read and write image data from and to TIFF files.";
    homepage = https://www.lfd.uci.edu/~gohlke/;
    maintainers = [ maintainers.lebastr ];
    license = licenses.bsd3;
  };
}
