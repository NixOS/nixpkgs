{stdenv, fetchurl, ncurses, glib, gettext, readline, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pal-0.4.2";
  src = fetchurl {
    url = "mirror://sourceforge/palcal/${name}.tgz";
    sha256 = "1601nsspxscm7bp9g9bkia0ij0mx2lpskl2fqhs5r0smp92121nx";
  };

  patchPhase = ''
    sed -i -e 's/-o root//' -e 's,ESTDIR}/etc,ESTDIR}'$out/etc, src/Makefile
    sed -i -e 's,/etc/pal\.conf,'$out/etc/pal.conf, src/input.c
  '';

  preBuild = ''
    export makeFlags="prefix=$out"
  '';

  buildInputs = [ glib gettext readline pkgconfig ];

  meta = {
    homepage = http://palcal.sourceforge.net/;
    description = "Command-line calendar program that can keep track of events";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
