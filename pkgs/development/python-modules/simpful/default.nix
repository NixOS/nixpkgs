{ buildPythonPackage
, fetchPypi
, lib
, numpy
, requests
, scipy
}:

buildPythonPackage rec {
  pname = "simpful";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KbDB/h2rXcnrE3z4rH+tXKREQzmL05F/FKN99tx/VaQ=";
  };

  propagatedBuildInputs = [
    numpy
    requests
    scipy
  ];

  meta = with lib; {
    description = "A Python library for fuzzy logic";
    homepage = "https://github.com/aresio/simpful";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
