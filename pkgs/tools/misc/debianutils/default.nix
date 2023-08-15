{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "debianutils";
  version = "5.8";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "sha256-WwhtJ+uQY95NdGdg0PrrQNlGT7hV/IqOf7k7A+/OxiI=";
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
