{ stdenv, kernel, elfutils }:

stdenv.mkDerivation {
  name = "perf-linux-${kernel.version}";

  inherit (kernel) src;

  preConfigure = ''
    cd tools/perf
    export makeFlags="DESTDIR=$out"
  '';

  buildInputs = [ elfutils ];

  meta = {
    homepage = https://perf.wiki.kernel.org/;
    description = "Linux tools to profile with performance counters";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
