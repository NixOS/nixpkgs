{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27, pythonOlder
, numpy, nose, enum34, futures, pathlib }:

buildPythonPackage rec {
  pname = "tifffile";
  version = "2018.10.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ca8ee9a54d10d2b38ec262cc65abb687f38c34aa9cda23bb22077cd48a9b1ff";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests --exe -v --exclude="test_extension"
  '';

  propagatedBuildInputs = [ numpy ]
    ++ lib.optional isPy27 [ futures pathlib ]
    ++ lib.optional (pythonOlder "3.0") enum34;

  meta = with stdenv.lib; {
    description = "Read and write image data from and to TIFF files.";
    homepage = https://github.com/blink1073/tifffile;
    maintainers = [ maintainers.lebastr ];
    license = licenses.bsd2;
  };
}
