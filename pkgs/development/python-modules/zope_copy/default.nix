{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_location
, zope_schema
}:


buildPythonPackage rec {
  pname = "zope_copy";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "eb2a95866df1377741876a3ee62d8600e80089e6246e1a235e86791b29534457";
  };

  propagatedBuildInputs = [ zope_interface ];

  checkInputs = [ zope_location zope_schema ];

  meta = {
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}