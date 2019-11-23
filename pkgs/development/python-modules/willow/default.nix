{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, pillow
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.3";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    pname = "Willow";
    inherit version;
    sha256 = "0dzc3cjkwp0h3v1n94c33zr5yw5fdd6dkm6vccp9i8dncmpw912g";
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
