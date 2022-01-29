{ lib, stdenv, kernel, elfutils, python2, python3, perl, newt, slang, asciidoc, xmlto, makeWrapper
, docbook_xsl, docbook_xml_dtd_45, libxslt, flex, bison, pkg-config, libunwind, binutils-unwrapped
, libiberty, audit, libbfd, libopcodes, openssl, systemtap, numactl
, zlib
, withGtk ? false, gtk2
, withZstd ? true, zstd
, withLibcap ? true, libcap
}:

with lib;

assert versionAtLeast kernel.version "3.12";

stdenv.mkDerivation {
  pname = "perf-linux";
  version = kernel.version;

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
    flex bison libiberty audit makeWrapper pkg-config python3
  ];
  buildInputs = [
    elfutils newt slang libunwind libbfd zlib openssl systemtap.stapBuild numactl
    libopcodes python3 perl
  ] ++ lib.optional withGtk gtk2
    ++ (if (versionAtLeast kernel.version "4.19") then [ python3 ] else [ python2 ])
    ++ lib.optional withZstd zstd
    ++ lib.optional withLibcap libcap;

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cpp"
    "-Wno-error=bool-compare"
    "-Wno-error=deprecated-declarations"
    "-Wno-error=stringop-truncation"
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  doCheck = false; # requires "sparse"
  doInstallCheck = false; # same

  separateDebugInfo = true;
  installFlags = [ "install" "install-man" "ASCIIDOC8=1" "prefix=$(out)" ];

  preFixup = ''
    # pull in 'objdump' into PATH to make annotations work
    wrapProgram $out/bin/perf \
      --prefix PATH : "${binutils-unwrapped}/bin"
  '';

  meta = {
    homepage = "https://perf.wiki.kernel.org/";
    description = "Linux tools to profile with performance counters";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
    broken = kernel.kernelOlder "5";
  };
}
