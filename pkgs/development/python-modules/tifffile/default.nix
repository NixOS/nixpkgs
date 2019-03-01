{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27, pythonOlder
, numpy, nose, enum34, futures, pathlib }:

buildPythonPackage rec {
  pname = "tifffile";
  # 2018.10.18 and 2018.11.6 are not releases...?
  # https://github.com/blink1073/tifffile/issues/54
  # anaconda uses 0.15.1
  version = "2019.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ead5f84c0b100f8100377b8ef2bcffaf21c249784ddc240346b715408b45f42c";
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
