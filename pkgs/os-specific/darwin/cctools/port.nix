{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, autoreconfHook, memstreamHook
, installShellFiles
, libuuid
, libobjc ? null, maloader ? null
, enableTapiSupport ? true, libtapi
, fetchpatch
}:

let

  # The targetPrefix prepended to binary names to allow multiple binuntils on the
  # PATH to both be usable.
  targetPrefix = lib.optionalString
    (stdenv.targetPlatform != stdenv.hostPlatform)
    "${stdenv.targetPlatform.config}-";
in

# Non-Darwin alternatives
assert (!stdenv.hostPlatform.isDarwin) -> maloader != null;

stdenv.mkDerivation {
  pname = "${targetPrefix}cctools-port";
  version = "973.0.1";

  src = fetchFromGitHub {
    owner  = "tpoechtrager";
    repo   = "cctools-port";
    # This is the commit before: https://github.com/tpoechtrager/cctools-port/pull/114
    # That specific change causes trouble for us (see the PR discussion), but
    # is also currently the last commit on master at the time of writing, so we
    # can just go back one step.
    rev    = "457dc6ddf5244ebf94f28e924e3a971f1566bd66";
    sha256 = "0ns12q7vg9yand4dmdsps1917cavfbw67yl5q7bm6kb4ia5kkx13";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ autoconf automake libtool autoreconfHook installShellFiles ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ memstreamHook ];
  buildInputs = [ libuuid ]
    ++ lib.optionals stdenv.isDarwin [ libobjc ]
    ++ lib.optional enableTapiSupport libtapi;

  patches = [
    ./ld-ignore-rpath-link.patch
    ./ld-rpath-nonfinal.patch
    (fetchpatch {
      url = "https://github.com/tpoechtrager/cctools-port/commit/4a734070cd2838e49658464003de5b92271d8b9e.patch";
      hash = "sha256-72KaJyu7CHXxJJ1GNq/fz+kW1RslO3UaKI91LhBtiXA=";
    })
    (fetchpatch {
      url = "https://github.com/MercuryTechnologies/cctools-port/commit/025899b7b3593dedb0c681e689e57c0e7bbd9b80.patch";
      hash = "sha256-SWVUzFaJHH2fu9y8RcU3Nx/QKx60hPE5zFx0odYDeQs=";
    })
    # Always use `open_memstream`. This is provided by memstream via hook on x86_64-darwin.
    ./darwin-memstream.patch
  ];

  __propagatedImpureHostDeps = [
    # As far as I can tell, otool from cctools is the only thing that depends on these two, and we should fix them
    "/usr/lib/libobjc.A.dylib"
    "/usr/lib/libobjc.dylib"
  ];

  enableParallelBuilding = true;

  # TODO(@Ericson2314): Always pass "--target" and always targetPrefix.
  configurePlatforms = [ "build" "host" ]
    ++ lib.optional (stdenv.targetPlatform != stdenv.hostPlatform) "target";
  configureFlags = [ "--disable-clang-as" ]
    ++ lib.optionals enableTapiSupport [
      "--enable-tapi-support"
      "--with-libtapi=${libtapi}"
    ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cctools/Makefile.am --replace libobjc2 ""
  '' + ''
    sed -i -e 's/addStandardLibraryDirectories = true/addStandardLibraryDirectories = false/' cctools/ld64/src/ld/Options.cpp

    # FIXME: there are far more absolute path references that I don't want to fix right now
    substituteInPlace cctools/configure.ac \
      --replace "-isystem /usr/local/include -isystem /usr/pkg/include" "" \
      --replace "-L/usr/local/lib" "" \

    # Appears to use new libdispatch API not available in macOS SDK 10.12.
    substituteInPlace cctools/ld64/src/ld/libcodedirectory.c \
      --replace "#define LIBCD_PARALLEL 1" ""

    patchShebangs tools
    sed -i -e 's/which/type -P/' tools/*.sh

    cd cctools
  '';

  preInstall = ''
    installManPage ar/ar.{1,5}

    # The makefile rules for installing headers are missing in 973.0.1.
    # The below is derived from 949.0.1.
    mkdir -p $dev/include/mach-o/i386
    mkdir -p $dev/include/mach-o/ppc
    mkdir -p $dev/include/mach-o/x86_64
    mkdir -p $dev/include/mach-o/arm
    mkdir -p $dev/include/mach-o/arm64
    mkdir -p $dev/include/mach-o/m68k
    mkdir -p $dev/include/mach-o/sparc
    mkdir -p $dev/include/mach-o/hppa
    mkdir -p $dev/include/mach-o/i860
    mkdir -p $dev/include/mach-o/m88k
    mkdir -p $dev/include/dyld
    mkdir -p $dev/include/cbt

    pushd include/mach-o
    install -c -m 444  arch.h ldsyms.h reloc.h \
      stab.h loader.h fat.h swap.h getsect.h nlist.h \
      ranlib.h $dev/include/mach-o
    popd

    pushd include/mach-o/i386
    install -c -m 444  swap.h \
      $dev/include/mach-o/i386
    popd

    pushd include/mach-o/ppc
    install -c -m 444  reloc.h swap.h \
      $dev/include/mach-o/ppc
    popd

    pushd include/mach-o/x86_64
    install -c -m 444  reloc.h \
      $dev/include/mach-o/x86_64
    popd

    pushd include/mach-o/arm
    install -c -m 444  reloc.h \
      $dev/include/mach-o/arm
    popd

    pushd include/mach-o/arm64
    install -c -m 444  reloc.h \
      $dev/include/mach-o/arm64
    popd

    pushd include/mach-o/m68k
    install -c -m 444  swap.h \
      $dev/include/mach-o/m68k
    popd

    pushd include/mach-o/sparc
    install -c -m 444  reloc.h swap.h \
      $dev/include/mach-o/sparc
    popd

    pushd include/mach-o/hppa
    install -c -m 444  reloc.h swap.h \
      $dev/include/mach-o/hppa
    popd

    pushd include/mach-o/i860
    install -c -m 444  reloc.h swap.h \
      $dev/include/mach-o/i860
    popd

    pushd include/mach-o/m88k
    install -c -m 444  reloc.h swap.h \
      $dev/include/mach-o/m88k
    popd

    pushd include/stuff
    install -c -m 444  bool.h \
      $dev/include/dyld
    popd

    pushd include/cbt
    install -c -m 444  libsyminfo.h \
      $dev/include/cbt
    popd
  '';

  passthru = {
    inherit targetPrefix;
  };

  meta = {
    broken = !stdenv.targetPlatform.isDarwin; # Only supports darwin targets
    homepage = "http://www.opensource.apple.com/source/cctools/";
    description = "MacOS Compiler Tools (cross-platform port)";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
