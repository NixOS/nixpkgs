{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "debianutils";
  version = "4.11";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/${pname}/${pname}_${version}.tar.xz";
    sha256 = "0lbizfnf3qwsiz2ggia6ff7sjjj8gwhys8bm6wixdc4n0qlycp5v";
  };

  meta = with stdenv.lib; {
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
       This package provides a number of small utilities which are used primarily by the installation scripts of Debian packages, although you may use them directly.

       The specific utilities included are: add-shell installkernel ischroot remove-shell run-parts savelog tempfile which
    '';
    downloadPage = "https://packages.debian.org/sid/debianutils";
    license = with licenses; [ gpl2Plus publicDomain smail ];
    maintainers = [];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
