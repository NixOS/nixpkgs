{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# dependencies
, filetype
, defusedxml,
}:

buildPythonPackage rec {
  pname = "willow";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "2.7";

  src = fetchPypi {
    pname = "Willow";
    inherit version;
    hash = "sha256-t6SQkRATP9seIodZLgZzzCVeAobhzVNCfuaN8ckiDEw=";
  };

  propagatedBuildInputs = [
    filetype
    defusedxml
  ];

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
