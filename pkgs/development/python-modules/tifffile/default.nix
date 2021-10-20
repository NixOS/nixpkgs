{ lib
, fetchPypi
, buildPythonPackage
, isPy27
, isPy3k
, numpy
, imagecodecs-lite
, enum34 ? null
, futures ? null
, pathlib ? null
, pytest
}:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2021.8.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8260f31c4700143e8374ff6cde5cef7fe54fc9b7313afe88329f407881901dc5";
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
