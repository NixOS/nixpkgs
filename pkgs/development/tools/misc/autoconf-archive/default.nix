{ lib, stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  pname = "autoconf-archive";
  version = "2022.02.11";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    sha256 = "sha256-eKYbYR4u61WongOY4M44e8r1f+LdU8b+QnEw93etHow=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];

  meta = with lib; {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
