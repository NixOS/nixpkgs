{ stdenv, kernelDev, elfutils, python, perl, newt, slang, asciidoc, xmlto
, docbook_xsl, docbook_xml_dtd_45, libxslt, flex, bison, pkgconfig
, withGtk ? false, gtk ? null }:

assert withGtk -> gtk != null;

stdenv.mkDerivation {
  name = "perf-linux-${kernelDev.version}";

  inherit (kernelDev) src patches;

  preConfigure = ''
    cd tools/perf
    sed -i s,/usr/include/elfutils,$elfutils/include/elfutils, Makefile
    export makeFlags="DESTDIR=$out $makeFlags"
  '';

  # perf refers both to newt and slang
  nativeBuildInputs = [ asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt flex bison ];
  buildInputs = [ elfutils python perl newt slang pkgconfig] ++
    stdenv.lib.optional withGtk gtk;

  installFlags = "install install-man ASCIIDOC8=1";

  inherit elfutils;

  crossAttrs = {
    /* I don't want cross-python or cross-perl -
       I don't know if cross-python even works */
    propagatedBuildInputs = [ elfutils.crossDrv newt.crossDrv ];
    makeFlags = "CROSS_COMPILE=${stdenv.cross.config}-";
    elfutils = elfutils.crossDrv;
  };

  meta = {
    homepage = https://perf.wiki.kernel.org/;
    description = "Linux tools to profile with performance counters";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
