{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27, pythonOlder
, numpy, nose, enum34, futures }:

buildPythonPackage rec {
  pname = "tifffile";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rqx2bar6dcsbmzq68mjh5bsyjzhbkqxi2dsv7j0vdbnjs5dfq9q";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests --exe -v --exclude="test_extension"
  '';

  propagatedBuildInputs = [ numpy ]
    ++ lib.optional isPy27 futures
    ++ lib.optional (pythonOlder "3.0") enum34;

  meta = with stdenv.lib; {
    description = "Read and write image data from and to TIFF files.";
    homepage = https://github.com/blink1073/tifffile;
    maintainers = [ maintainers.lebastr ];
    license = licenses.bsd2;
  };
}
