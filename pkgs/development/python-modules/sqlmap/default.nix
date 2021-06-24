{ lib
, buildPythonPackage
, fetchPypi
, file
, stdenv
}:

buildPythonPackage rec {
  pname = "sqlmap";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b2Q5Zelz0AWbNQotOLWdwN5+20Q5jATH3nzLEJQRwno=";
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
