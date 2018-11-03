{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, pillow
}:

buildPythonPackage rec {
  pname = "willow";
  version = "0.2.2";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "111c82fbfcda2710ce6201b0b7e0cfa1ff3c4f2f0dc788cc8dfc8db933c39c73";
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
