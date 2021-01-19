{ lib, stdenv, fetchurl, ncurses, glib, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  name = "latencytop-0.5";

  patchPhase = "sed -i s,/usr,$out, Makefile";
  preInstall = "mkdir -p $out/sbin";

  src = fetchurl {
    urls = [ "http://latencytop.org/download/${name}.tar.gz"
     "http://dbg.download.sourcemage.org/mirror/latencytop-0.5.tar.gz" ];
    sha256 = "1vq3j9zdab6njly2wp900b3d5244mnxfm88j2bkiinbvxbxp4zwy";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses glib gtk2 ];

  meta = {
    homepage = "http://latencytop.org";
    description = "Tool to show kernel reports on latencies (LATENCYTOP option)";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.linux;
  };
}
