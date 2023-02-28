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
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-epg2yjqX9m1WGzYPeGUBKGif4JNAddzg75ECe9xPOlc=";
  };

  propagatedBuildInputs = [ zope_interface ];

  doCheck = !isPy27; # namespace conflicts
  nativeCheckInputs = [ unittestCheckHook zope_location zope_schema ];

  unittestFlagsArray = [ "-s" "src/zope/copy" ];

  meta = {
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
