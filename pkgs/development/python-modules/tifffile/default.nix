{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27, pythonOlder
, numpy, nose, enum34, futures }:

buildPythonPackage rec {
  pname = "tifffile";
  version = "0.13.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bca0fc9eaf609a27ebd99d8466e05d5a6e79389957f17582b70643dbca65e3d8";
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
