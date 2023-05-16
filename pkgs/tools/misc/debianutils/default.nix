<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "debianutils";
  version = "5.8";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/debianutils/debianutils_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-WwhtJ+uQY95NdGdg0PrrQNlGT7hV/IqOf7k7A+/OxiI=";
  };

  outputs = [ "out" "man" ];

  meta = {
    homepage = "https://packages.debian.org/sid/debianutils";
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
       This package provides a number of small utilities which are used
       primarily by the installation scripts of Debian packages, although you
       may use them directly.

       The specific utilities included are: add-shell installkernel ischroot
       remove-shell run-parts savelog tempfile which
    '';
    license = with lib.licenses; [ gpl2Plus publicDomain smail ];
    mainProgram = "ischroot";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "debianutils";
  version = "5.7";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "sha256-J+yeDn5E3Iq2EapXYzBHG6ywfkSR/+zw06ppCckvkCI=";
  };

  meta = with lib; {
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
       This package provides a number of small utilities which are used primarily by the installation scripts of Debian packages, although you may use them directly.

       The specific utilities included are: add-shell installkernel ischroot remove-shell run-parts savelog tempfile which
    '';
    downloadPage = "https://packages.debian.org/sid/debianutils";
    license = with licenses; [ gpl2Plus publicDomain smail ];
    maintainers = [];
    platforms = platforms.all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
