{ lib, fetchPypi, buildPythonPackage, isPy27
, numpy, enum34, futures, pathlib
, pytest
}:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2019.2.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed49d75b3eff711dbe74b35324dfd79e0db598b6e772a9096001545e81e95437";
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
