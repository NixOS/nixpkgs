{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bb2dc8a59f3128662f958d647c5e6755f9ad8053f216c88e68514df204926d2";
  };

  meta = with lib; {
    homepage = "https://github.com/joshy/striprtf";
    description = "A simple library to convert rtf to text";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
