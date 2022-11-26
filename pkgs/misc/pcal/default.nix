{ lib, stdenv, fetchurl, pkgs, gccmakedep }:

stdenv.mkDerivation rec {
  pname = "pcal";
  version = "4.11.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/pcal/pcal/pcal-${version}/pcal-${version}.tgz";
    sha256 = "01yjz1qckh3cp5yjjlma977gm60swczbcw9b4qcjf20jg471j1l4";
  };

  nativeBuildInputs = [ gccmakedep pkgs.groff ];

  installFlags = [ "DESTDIR=$(out)/" "BINDIR=bin" "MANDIR=man1" "CATDIR=cat1" "PACK=gzip" ];

  buildFlags = [ "CC=${pkgs.gcc}/bin/gcc" ];

  meta = with lib; {
    homepage = "https://pcal.sourceforge.net";
    description = "PCAL is a calendar-generation program which produces nice-looking PostScript output";
    platforms = platforms.all;
    maintainers = [ maintainers.afwlehmann ];
    license = [ licenses.free ];
  };
}

