{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "debianutils";
  version = "4.11.2";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/${pname}/${pname}_${version}.tar.xz";
    sha256 = "1pjh2s5f8qp8jaky2x08yvf125np0s48zb2z6f3h6x4vf20hws1v";
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
