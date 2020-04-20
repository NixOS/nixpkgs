{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, file
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0chnb421g4bsshbkx6d1xnhsda4250jsn8zyklg5p1vqyr12mhik";
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
