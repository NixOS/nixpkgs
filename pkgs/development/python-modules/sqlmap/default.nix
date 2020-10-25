{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, file
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.4.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cef7d8ae2e2cd829d49535aa2047c58b25e429e80f148e29063fbe2b2acf97f";
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

  meta = with lib; {
    homepage = "http://sqlmap.org";
    license = licenses.gpl2;
    description = "Automatic SQL injection and database takeover tool";
    maintainers = with maintainers; [ bennofs ];
  };
}
