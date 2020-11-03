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
  version = "2020.8.25";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b51e496bd9ee9c6875170a018bdb7b6f67e3946c4ab57afdb95b18b2c6937783";
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
