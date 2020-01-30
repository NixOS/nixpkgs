{ lib, stdenv, kernel, elfutils, python2, python3, perl, newt, slang, asciidoc, xmlto, makeWrapper
, docbook_xsl, docbook_xml_dtd_45, libxslt, flex, bison, pkgconfig, libunwind, binutils
, libiberty, audit, libbfd, libopcodes, openssl, systemtap, numactl
, zlib, withGtk ? false, gtk2 ? null
}:

with lib;

assert withGtk -> gtk2 != null;
assert versionAtLeast kernel.version "3.12";

stdenv.mkDerivation {
  name = "perf-linux-${kernel.version}";

  inherit (kernel) src;

  preConfigure = ''
    cd tools/perf

    substituteInPlace Makefile \
      --replace /usr/include/elfutils $elfutils/include/elfutils

    for x in util/build-id.c util/dso.c; do
      substituteInPlace $x --replace /usr/lib/debug /run/current-system/sw/lib/debug
    done

    if [ -f bash_completion ]; then
      sed -i 's,^have perf,_have perf,' bash_completion
    fi
  '';

  makeFlags = ["prefix=$(out)" "WERROR=0"] ++ kernel.makeFlags;

  hardeningDisable = [ "format" ];

  # perf refers both to newt and slang
  nativeBuildInputs = [
    asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt
    flex bison libiberty audit makeWrapper pkgconfig python3
  ];
  buildInputs = [
    elfutils newt slang libunwind libbfd zlib openssl systemtap.stapBuild numactl
    libopcodes python3 perl
  ] ++ stdenv.lib.optional withGtk gtk2
    ++ (if (versionAtLeast kernel.version "4.19") then [ python3 ] else [ python2 ]);

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cpp"
    "-Wno-error=bool-compare"
    "-Wno-error=deprecated-declarations"
    "-DOBJDUMP_PATH=\"${binutils}/bin/objdump\""
    "-Wno-error=stringop-truncation"
  ];

  postPatch = ''
    patchShebangs scripts/bpf_helpers_doc.py
  '';

  doCheck = false; # requires "sparse"
  doInstallCheck = false; # same

  separateDebugInfo = true;
  installFlags = [ "install" "install-man" "ASCIIDOC8=1" "prefix=$(out)" ];

  preFixup = ''
    wrapProgram $out/bin/perf \
      --prefix PATH : "${binutils}/bin"
  '';

  meta = {
    homepage = https://perf.wiki.kernel.org/;
    description = "Linux tools to profile with performance counters";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
