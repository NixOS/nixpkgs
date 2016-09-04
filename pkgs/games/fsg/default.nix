{ stdenv, fetchurl, gtk, glib, pkgconfig, mesa, wxGTK, libX11, xproto }:

stdenv.mkDerivation {
  name = "fsg-4.4";

  src = fetchurl {
    url = http://www.sourcefiles.org/Games/Simulation/Other/fsg-src-4.4.tar.gz;
    sha256 = "1756y01rkvd3f1pkj88jqh83fqcfl2fy0c48mcq53pjzln9ycv8c";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ gtk glib pkgconfig mesa wxGTK libX11 xproto ];

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
