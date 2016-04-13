{ stdenv, fetchurl, fetchzip, giblib, xlibsWrapper }:

let
  debPatch = fetchzip {
    url = mirror://debian/pool/main/s/scrot/scrot_0.8-17.debian.tar.xz;
    sha256 = "0ydsr3vah5wkcbnp91knkdbil4hx0cn0iy57frl03azqzc29bkw5";
  };
in
stdenv.mkDerivation rec {
  name = "scrot-0.8-17";

  src = fetchurl {
    url = "http://linuxbrit.co.uk/downloads/${name}.tar.gz";
    sha256 = "1wll744rhb49lvr2zs6m93rdmiq59zm344jzqvijrdn24ksiqgb1";
  };

  inherit debPatch;

  postPatch = ''
    for patch in $(cat $debPatch/patches/series); do
      patch -p1 < "$debPatch/patches/$patch"
    done
  '';

  buildInputs = [ giblib xlibsWrapper ];

  meta = with stdenv.lib; {
    homepage = http://linuxbrit.co.uk/scrot/;
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
  };
}
