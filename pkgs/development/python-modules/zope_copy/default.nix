{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_location
, zope_schema
}:


buildPythonPackage rec {
  pname = "zope.copy";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "702dbb52e2427a1cc2e2b4b3f5a40c64dcbf9ebed85888ae8fa67172263a6994";
  };

  propagatedBuildInputs = [ zope_interface ];

  checkInputs = [ zope_location zope_schema ];

  checkPhase = ''
    python -m unittest discover -s src/zope/copy
  '';

  meta = {
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
