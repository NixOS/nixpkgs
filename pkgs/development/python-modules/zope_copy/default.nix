{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, zope_interface
, zope_location
, zope_schema
, unittestCheckHook
}:


buildPythonPackage rec {
  pname = "zope.copy";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47bb9d09ff06c600b446f220f47a742396598ac4828d738d3d85e6490629a71a";
  };

  propagatedBuildInputs = [ zope_interface ];

  doCheck = !isPy27; # namespace conflicts
  checkInputs = [ unittestCheckHook zope_location zope_schema ];

  unittestFlagsArray = [ "-s" "src/zope/copy" ];

  meta = {
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
