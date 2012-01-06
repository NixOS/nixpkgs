{ stdenv, kernel, elfutils, python, perl, newt, slang }:

stdenv.mkDerivation {
  name = "perf-linux-${kernel.version}";

  inherit (kernel) src;

  preConfigure = ''
    cd tools/perf
    sed -i s,/usr/include/elfutils,$elfutils/include/elfutils, Makefile
    export makeFlags="DESTDIR=$out $makeFlags"
  '';

  # perf refers both to newt and slang
  buildInputs = [ elfutils python perl newt slang ];

  inherit elfutils;

  crossAttrs = {
    /* I don't want cross-python or cross-perl -
       I don't know if cross-python even works */
    propagatedBuildInputs = [ elfutils.hostDrv newt.hostDrv ];
    makeFlags = "CROSS_COMPILE=${stdenv.cross.config}-";
    elfutils = elfutils.hostDrv;
  };

  meta = {
    homepage = https://perf.wiki.kernel.org/;
    description = "Linux tools to profile with performance counters";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
