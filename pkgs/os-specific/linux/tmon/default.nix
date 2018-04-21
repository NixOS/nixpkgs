{ stdenv, kernel, ncurses }:

stdenv.mkDerivation {
  name = "tmon-${kernel.version}";

  inherit (kernel) src;

  buildInputs = [ ncurses ];

  configurePhase = ''
    cd tools/thermal/tmon
  '';

  makeFlags = kernel.makeFlags ++ [ "INSTALL_ROOT=\"$(out)\"" "BINDIR=bin" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Monitoring and Testing Tool for Linux kernel thermal subsystem";
    homepage = https://www.kernel.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
