{ lib
, buildPythonPackage
, fetchPypi
, jellyfish
}:

buildPythonPackage rec {
  pname = "us";
  version = "2.0.2";

  propagatedBuildInputs = [ jellyfish ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb11ad0d43deff3a1c3690c74f0c731cff5b862c73339df2edd91133e1496fbc";
  };

  # Upstream requires jellyfish==0.5.6 but we have 0.6.1
  postPatch = ''
    substituteInPlace setup.py --replace "jellyfish==" "jellyfish>="
  '';

  doCheck = false; # pypi version doesn't include tests

  meta = {
    description = "A package for easily working with US and state metadata";
    longDescription = ''
    all US states and territories, postal abbreviations, Associated Press style
    abbreviations, FIPS codes, capitals, years of statehood, time zones, phonetic
    state name lookup, is contiguous or continental, URLs to shapefiles for state,
    census, congressional districts, counties, and census tracts
    '';
    homepage = "https://github.com/unitedstates/python-us/";
    license = lib.licenses.bsd3;
  };
}
