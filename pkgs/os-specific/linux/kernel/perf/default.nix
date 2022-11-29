{ lib
, stdenv
, fetchpatch
, fetchurl
, kernel
, elfutils
, python3
, perl
, newt
, slang
, asciidoc
, xmlto
, makeWrapper
, docbook_xsl
, docbook_xml_dtd_45
, libxslt
, flex
, bison
, pkg-config
, libunwind
, binutils-unwrapped
, libiberty
, audit
, libbfd
, libbfd_2_38
, libopcodes
, libopcodes_2_38
, openssl
, systemtap
, numactl
, zlib
, babeltrace
, withGtk ? false
, gtk2
, withZstd ? true
, zstd
, withLibcap ? true
, libcap
}:
let
  d3-flame-graph-templates = stdenv.mkDerivation rec {
    pname = "d3-flame-graph-templates";
    version = "4.1.3";

    src = fetchurl {
      url = "https://registry.npmjs.org/d3-flame-graph/-/d3-flame-graph-${version}.tgz";
      sha256 = "sha256-W5/Vh5jarXUV224aIiTB2TnBFYT3naEIcG2945QjY8Q=";
    };

    installPhase = ''
      install -D -m 0755 -t $out/share/d3-flame-graph/ ./dist/templates/*
    '';
  };
in

stdenv.mkDerivation {
  pname = "perf-linux";
  version = kernel.version;

  inherit (kernel) src;

  postPatch = ''
    # Linux scripts
    patchShebangs scripts

    cd tools/perf

    for x in util/build-id.c util/dso.c; do
      substituteInPlace $x --replace /usr/lib/debug /run/current-system/sw/lib/debug
    done

  '' + lib.optionalString (lib.versionAtLeast kernel.version "5.8") ''
    substituteInPlace scripts/python/flamegraph.py \
      --replace "/usr/share/d3-flame-graph/d3-flamegraph-base.html" \
      "${d3-flame-graph-templates}/share/d3-flame-graph/d3-flamegraph-base.html"

  '' + lib.optionalString (lib.versionAtLeast kernel.version "6.0") ''
    patchShebangs pmu-events/jevents.py
  '';

  makeFlags = [ "prefix=$(out)" "WERROR=0" "ASCIIDOC8=1" ] ++ kernel.makeFlags
    ++ lib.optional (!withGtk) "NO_GTK2=1"
    ++ lib.optional (!withZstd) "NO_LIBZSTD=1"
    ++ lib.optional (!withLibcap) "NO_LIBCAP=1";

  hardeningDisable = [ "format" ];

  # perf refers both to newt and slang
  nativeBuildInputs = [
    asciidoc
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    libxslt
    flex
    bison
    libiberty
    audit
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    elfutils
    newt
    slang
    libunwind
    zlib
    openssl
    systemtap.stapBuild
    numactl
    python3
    perl
    babeltrace
  ] ++ (if (lib.versionAtLeast kernel.version "5.19")
  then [ libbfd libopcodes ]
  else [ libbfd_2_38 libopcodes_2_38 ])
  ++ lib.optional withGtk gtk2
  ++ lib.optional withZstd zstd
  ++ lib.optional withLibcap libcap
  ++ lib.optional (lib.versionAtLeast kernel.version "6.0") python3.pkgs.setuptools;

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cpp"
    "-Wno-error=bool-compare"
    "-Wno-error=deprecated-declarations"
    "-Wno-error=stringop-truncation"
  ];

  doCheck = false; # requires "sparse"

  installTargets = [ "install" "install-man" ];

  # TODO: Add completions based on perf-completion.sh
  postInstall = ''
    # Same as perf. Remove.
    rm -f $out/bin/trace
  '';

  separateDebugInfo = true;

  preFixup = ''
    # Pull in 'objdump' into PATH to make annotations work.
    # The embeded Python interpreter will search PATH to calculate the Python path configuration(Should be fixed by upstream).
    # Add python.interpreter to PATH for now.
    wrapProgram $out/bin/perf \
      --prefix PATH : ${lib.makeBinPath [ binutils-unwrapped python3 ]}
  '';

  meta = with lib; {
    homepage = "https://perf.wiki.kernel.org/";
    description = "Linux tools to profile with performance counters";
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5";
  };
}
