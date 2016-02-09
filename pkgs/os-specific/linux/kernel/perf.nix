{ lib, stdenv, kernel, elfutils, python, perl, newt, slang, asciidoc, xmlto
, docbook_xsl, docbook_xml_dtd_45, libxslt, flex, bison, pkgconfig, libunwind, binutils
, zlib, withGtk ? false, gtk ? null }:

with lib;

assert withGtk -> gtk != null;
assert versionAtLeast kernel.version "3.12";

stdenv.mkDerivation {
  name = "perf-linux-${kernel.version}";

  inherit (kernel) src patches;

  preConfigure = ''
    cd tools/perf
    sed -i s,/usr/include/elfutils,$elfutils/include/elfutils, Makefile
    ${optionalString (versionOlder kernel.version "3.13") "patch -p1 < ${./perf.diff}"}
    [ -f bash_completion ] && sed -i 's,^have perf,_have perf,' bash_completion
    export makeFlags="DESTDIR=$out $makeFlags"
  '';

  # perf refers both to newt and slang
  # binutils is required for libbfd.
  nativeBuildInputs = [ asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt flex bison ];
  buildInputs = [ python perl newt slang pkgconfig libunwind binutils zlib ] ++
    stdenv.lib.optional withGtk gtk;

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = "-I${elfutils}/include -Wno-error=cpp -Wno-error=bool-compare";
  NIX_CFLAGS_LINK = "-L${elfutils}/lib";

  installFlags = "install install-man ASCIIDOC8=1";

  inherit elfutils;

  crossAttrs = {
    /* I don't want cross-python or cross-perl -
       I don't know if cross-python even works */
    propagatedBuildInputs = [ elfutils.crossDrv newt.crossDrv ];
    makeFlags = "CROSS_COMPILE=${stdenv.cross.config}-";
    elfutils = elfutils.crossDrv;
    inherit (kernel.crossDrv) src patches;
  };

  meta = {
    homepage = https://perf.wiki.kernel.org/;
    description = "Linux tools to profile with performance counters";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
