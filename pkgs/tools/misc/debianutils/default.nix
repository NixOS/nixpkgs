{ stdenv, fetchurl }:

let
  checksums = {
    "4.8.1" = "09phylg8ih1crgxjadkdb8idbpj9ap62a7cbh8qdx2gyvh5mqf9c";
  };
  smail = {
    shortName = "smail";
    fullName = "SMAIL General Public License";
    url = http://metadata.ftp-master.debian.org/changelogs/main/d/debianutils/debianutils_4.8.1_copyright;
  };
in stdenv.mkDerivation rec {
  version = "4.8.1";
  name = "debianutils-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/debianutils/debianutils_${version}.tar.xz";
    sha256 = checksums."${version}";
  };

  meta = {
    description = "Miscellaneous utilities specific to Debian";
    longDescription = ''
       This package provides a number of small utilities which are used primarily by the installation scripts of Debian packages, although you may use them directly.

       The specific utilities included are: add-shell installkernel ischroot remove-shell run-parts savelog tempfile which 
    '';
    downloadPage = https://packages.debian.org/sid/debianutils;
    license = with stdenv.lib.license; [ gpl2Plus publicDomain smail ];
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
