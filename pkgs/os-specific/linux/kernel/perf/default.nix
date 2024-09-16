{ lib
, stdenv
, fetchurl
, fetchpatch
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
, libpfm
, libtraceevent
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

  # Fix 6.10.0 holding pkg-config completely wrong.
  # Patches from perf-tools-next, should be in 6.11 or hopefully backported.
  patches = lib.optionals (lib.versions.majorMinor kernel.version == "6.10") [
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/patch/?id=0f0e1f44569061e3dc590cd0b8cb74d8fd53706b";
      hash = "sha256-9u/zhbsDgwOr4T4k9td/WJYRuSHIfbtfS+oNx8nbOlM=";
    })
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/patch/?id=366e17409f1f17ad872259ce4a4f8a92beb4c4ee";
      hash = "sha256-NZK1u40qvMwWcgkgJPGpEax2eMo9xHrCQxSYYOK0rbo=";
    })
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/patch/?id=1d302f626c2a23e4fd05bb810eff300e8f2174fd";
      hash = "sha256-KhCmof8LkyTcBBpfMEtolL3m3kmC5rukKzQvufVKCdI=";
    })
  ];

  postPatch = ''
    # Linux scripts
    patchShebangs scripts
    patchShebangs tools/perf/check-headers.sh
  '' + lib.optionalString (lib.versionAtLeast kernel.version "6.3") ''
    # perf-specific scripts
    patchShebangs tools/perf/pmu-events
  '' + ''
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
    libtraceevent
    libunwind
    zlib
    openssl
    numactl
    python3
    perl
    babeltrace
  ] ++ (if (lib.versionAtLeast kernel.version "5.19")
  then [ libbfd libopcodes ]
  else [ libbfd_2_38 libopcodes_2_38 ])
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform systemtap) systemtap.stapBuild
  ++ lib.optional withGtk gtk2
  ++ lib.optional withZstd zstd
  ++ lib.optional withLibcap libcap
  ++ lib.optional (lib.versionAtLeast kernel.version "5.8") libpfm
  ++ lib.optional (lib.versionAtLeast kernel.version "6.0") python3.pkgs.setuptools;

  env.NIX_CFLAGS_COMPILE = toString [
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
    # The embedded Python interpreter will search PATH to calculate the Python path configuration(Should be fixed by upstream).
    # Add python.interpreter to PATH for now.
    wrapProgram $out/bin/perf \
      --prefix PATH : ${lib.makeBinPath [ binutils-unwrapped python3 ]}
  '';

  meta = with lib; {
    homepage = "https://perf.wiki.kernel.org/";
    description = "Linux tools to profile with performance counters";
    mainProgram = "perf";
    maintainers = with maintainers; [ tobim ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5";
  };
}
