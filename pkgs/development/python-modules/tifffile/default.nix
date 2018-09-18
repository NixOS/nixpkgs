{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27, pythonOlder
, numpy, nose, enum34, futures, pathlib }:

buildPythonPackage rec {
  pname = "tifffile";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fbb2cfd57fd8e42e417bc29001a17f319701f1be00e0b8a0004a52da93f1b08";
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
