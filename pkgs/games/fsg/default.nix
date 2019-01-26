{ stdenv, fetchurl, gtk2, glib, pkgconfig, libGLU_combined, wxGTK, libX11, xorgproto }:

stdenv.mkDerivation {
  name = "fsg-4.4";

  src = fetchurl {
    name = "fsg-src-4.4.tar.gz";
    url = "https://github.com/ctrlcctrlv/wxsand/blob/master/fsg-src-4.4-ORIGINAL.tar.gz?raw=true";
    sha256 = "1756y01rkvd3f1pkj88jqh83fqcfl2fy0c48mcq53pjzln9ycv8c";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 glib libGLU_combined wxGTK libX11 xorgproto ];

  preBuild = ''
    sed -e '
      s@currentProbIndex != 100@0@;
    ' -i MainFrame.cpp
    sed -re '/ctrans_prob/s/energy\[center][+]energy\[other]/(int)(fmin(energy[center]+energy[other],99))/g' -i Canvas.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp sand $out/libexec
    echo -e '#!${stdenv.shell}\nLC_ALL=C '$out'/libexec/sand "$@"' >$out/bin/fsg
    chmod a+x $out/bin/fsg
  '';

  meta = {
    description = "Cellular automata engine tuned towards the likes of Falling Sand";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
