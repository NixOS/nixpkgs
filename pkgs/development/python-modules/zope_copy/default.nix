{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_location
, zope_schema
}:


buildPythonPackage rec {
  pname = "zope.copy";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47bb9d09ff06c600b446f220f47a742396598ac4828d738d3d85e6490629a71a";
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
