{ fetchurl, stdenv, unzip }:

let
  rev = "3ec908d539";
in
stdenv.mkDerivation {
  name = "hardlink-2012.9.${rev}";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/cgit/hardlink.git/snapshot/hardlink-${rev}.zip";
    sha256 = "fea1803170b538d5fecf6a8d312ded1d25d516e9386a3797441a247487551647";
    name = "hardlink-${rev}.zip";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cc -O2 hardlink.c -o $out/bin/hardlink
    mv hardlink.1 $out/share/man/man1/hardlink.1
  '';

  buildInputs = [ unzip ];

  meta = {
    homepage = http://pkgs.fedoraproject.org/cgit/hardlink.git/;
    description = "Consolidate duplicate files via hardlinks";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
