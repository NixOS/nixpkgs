{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, pillow
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.4";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    pname = "Willow";
    inherit version;
    sha256 = "0b3lh7z98nlh4yn0cmvk7bimhfk5w4qvbmjr6jn880ji9h2ixq6d";
  };

  propagatedBuildInputs = [ six pillow ];

  # Test data is not included
  # https://github.com/torchbox/Willow/issues/34
  doCheck = false;

  meta = with lib; {
    description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
