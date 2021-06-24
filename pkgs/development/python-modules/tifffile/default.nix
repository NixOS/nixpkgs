{ lib
, fetchPypi
, buildPythonPackage
, isPy27
, isPy3k
, numpy
, imagecodecs-lite
, enum34
, futures
, pathlib
, pytest
}:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2020.11.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c712df6f201385fbd3500e26e45dc20fabcbb0c6c1fbfb4c1e44538a9d0269a8";
  };

  patches = lib.optional isPy27 ./python2-regex-compat.patch;

  # Missing dependencies: imagecodecs, czifile, cmapfile, oiffile, lfdfiles
  # and test data missing from PyPI tarball
  doCheck = false;

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [
    numpy
  ] ++ lib.optionals isPy3k [
    imagecodecs-lite
  ] ++ lib.optionals isPy27 [
    futures
    enum34
    pathlib
  ];

  meta = with lib; {
    description = "Read and write image data from and to TIFF files.";
    homepage = "https://www.lfd.uci.edu/~gohlke/";
    maintainers = [ maintainers.lebastr ];
    license = licenses.bsd3;
  };
}
