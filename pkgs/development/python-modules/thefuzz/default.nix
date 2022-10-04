{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "thefuzz";
  version = "0.19.0";

  src = fetchPypi {
    inherit version;
    pname = pname;
    sha256 = "sha256-b3Em2y8silQhKwXjp0DkX0KRxJfXXSB1Fyj2Nbt0qj0=";
  };

  doCheck = false;
  # checkInputs = [ pytest ];
  propagatedBuildInputs = [
  ];

  meta = with lib; {
    homepage = "https://github.com/seatgeek/thefuzz";
    description = "Fuzzy string matching like a boss. It uses Levenshtein Distance to calculate the differences between sequences";
    license = licenses.gpl2;
  };
}
