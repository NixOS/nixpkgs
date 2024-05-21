{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, zope-interface
, zope-location
, zope-schema
, unittestCheckHook
}:


buildPythonPackage rec {
  pname = "zope.copy";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-epg2yjqX9m1WGzYPeGUBKGif4JNAddzg75ECe9xPOlc=";
  };

  propagatedBuildInputs = [ zope-interface ];

  doCheck = !isPy27; # namespace conflicts
  nativeCheckInputs = [ unittestCheckHook zope-location zope-schema ];

  unittestFlagsArray = [ "-s" "src/zope/copy" ];

  meta = {
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
