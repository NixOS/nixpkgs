{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e122b5d334cda9b0edb3eeb8910f01d0ffb02eaca054facd75b17b98fcf646f5";
  };

  meta = with lib; {
    homepage = "https://github.com/joshy/striprtf";
    description = "A simple library to convert rtf to text";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
