{ lib, stdenv, fetchurl, gettext, gawk, bash }:

stdenv.mkDerivation rec {
  pname = "m17n-db";
<<<<<<< HEAD
  version = "1.8.2";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-db-${version}.tar.gz";
    sha256 = "sha256-vHR+J9ct9YoH9DG3JdeuQJIyLbxGEUykBTgoIbK6XGk=";
=======
  version = "1.8.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-db-${version}.tar.gz";
    sha256 = "0vfw7z9i2s9np6nmx1d4dlsywm044rkaqarn7akffmb6bf1j6zv5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [ gettext gawk bash ];

  strictDeps = true;

  configureFlags = [ "--with-charmaps=${stdenv.cc.libc}/share/i18n/charmaps" ]
  ;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (database)";
<<<<<<< HEAD
    changelog = "https://git.savannah.nongnu.org/cgit/m17n/m17n-db.git/plain/NEWS?h=REL-${lib.replaceStrings [ "." ] [ "-" ] version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
