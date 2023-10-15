{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "text2digits";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oB2NyNVxediIulid9A4Ccw878t2JKrIsN1OOR5lyi7I=";
  };

  propagatedBuildInputs = [ ];

  pythonImportsCheck = [ "text2digits" ];

  meta = with lib; {
    description = "A small library to convert text numbers to digits in a string";
    homepage = "https://github.com/careless25/text2digits";
    license = licenses.mit;
    maintainers = with maintainers; [ provenzano ];
  };
}
