{ lib
, buildPythonPackage
, fetchPypi
, file
, stdenv
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1714780f8835854c6f949f854fca936c3064b9a7e0da96989bb637a6ba5c119b";
  };

  postPatch = ''
    substituteInPlace sqlmap/thirdparty/magic/magic.py --replace "ctypes.util.find_library('magic')" \
      "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"

    # the check for the last update date does not work in Nix,
    # since the timestamp of the all files in the nix store is reset to the unix epoch
    echo 'LAST_UPDATE_NAGGING_DAYS = float("inf")' >> sqlmap/lib/core/settings.py
  '';

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "sqlmap" ];

  meta = with lib; {
    description = "Automatic SQL injection and database takeover tool";
    homepage = "http://sqlmap.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bennofs ];
  };
}
