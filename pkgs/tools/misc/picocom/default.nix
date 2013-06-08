{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "picocom-1.7";

  src = fetchurl {
    url = "http://picocom.googlecode.com/files/${name}.tar.gz";
    sha256 = "17hjq713naq02xar711aw24qqd52p591mj1h5n97cni1ga7irwyh";
  };

  installPhase = ''
    ensureDir $out/bin $out/share/man/man8
    cp picocom $out/bin
    cp picocom.8 $out/share/man/man8
  '';

  meta = {
    description = "Minimal dumb-terminal emulation program";
    homepage = http://code.google.com/p/picocom/;
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
