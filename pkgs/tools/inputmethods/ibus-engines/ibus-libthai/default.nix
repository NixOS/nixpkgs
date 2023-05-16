<<<<<<< HEAD
{ lib, stdenv, fetchurl, pkg-config, ibus, gtk3, libthai }:
=======
{ lib, stdenv, fetchurl, makeWrapper, pkg-config, ibus, gtk3, libthai }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "ibus-libthai";
  version = "0.1.5";

  src = fetchurl {
    url = "https://linux.thai.net/pub/ThaiLinux/software/libthai/ibus-libthai-${version}.tar.xz";
    sha256 = "sha256-egAxttjwuKiDoIuJluoOTJdotFZJe6ZOmJgdiFCAwx0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ibus libthai ];

  meta = with lib; {
    isIbusEngine = true;
    homepage = "https://linux.thai.net/projects/ibus-libthai";
    description = "Thai input method engine for IBus";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
