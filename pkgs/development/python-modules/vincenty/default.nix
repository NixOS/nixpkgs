{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "vincenty";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0nkqhbhrqar4jab7rvxfyjh2sh8d9v6ir861f6yrqdjzhggg58pa";
  };

  # Project does not have any tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/maurycyp/vincenty/;
    description = " Calculate the geographical distance between 2 points with extreme accuracy";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ f-breidenstein ];
  };
}


