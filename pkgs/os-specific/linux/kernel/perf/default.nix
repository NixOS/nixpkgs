{ lib, stdenv, fetchpatch, kernel, elfutils, python2, python3, perl, newt, slang, asciidoc, xmlto, makeWrapper
, docbook_xsl, docbook_xml_dtd_45, libxslt, flex, bison, pkg-config, libunwind, binutils-unwrapped
, libiberty, audit, libbfd, libbfd_2_38, libopcodes, libopcodes_2_38, openssl, systemtap, numactl
, zlib
, withGtk ? false, gtk2
, withZstd ? true, zstd
, withLibcap ? true, libcap
}:

stdenv.mkDerivation {
  pname = "perf-linux";
  version = kernel.version;

  inherit (kernel) src;

  patches = lib.optionals (lib.versionAtLeast kernel.version "5.19" && lib.versionOlder kernel.version "5.20") [
    # binutils-2.39 support around init_disassemble_info()
    # API change.
    # Will be included in 5.20.
    ./5.19-binutils-2.39-support.patch
  ];

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
    elfutils newt slang libunwind zlib openssl systemtap.stapBuild numactl
    python3 perl
  ] ++ (if (lib.versionAtLeast kernel.version "5.19")
            then [ libbfd libopcodes ]
            else [ libbfd_2_38 libopcodes_2_38 ])
    ++ lib.optional withGtk gtk2
    ++ (if (lib.versionAtLeast kernel.version "4.19") then [ python3 ] else [ python2 ])
    ++ lib.optional withZstd zstd
    ++ lib.optional withLibcap libcap;

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

  meta = with lib; {
    homepage = "https://perf.wiki.kernel.org/";
    description = "Linux tools to profile with performance counters";
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5";
  };
}
