{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, pillow
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.1";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "818ee11803c90a0a6d49c94b0453d6266be1ef83ae00de72731c45fae4d3e78c";
  };

  propagatedBuildInputs = [ six pillow ];

  # Test data is not included
  # https://github.com/torchbox/Willow/issues/34
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = https://github.com/torchbox/Willow/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
