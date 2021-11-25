{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, autoreconfHook
, installShellFiles
, libuuid
, libobjc ? null, maloader ? null
, enableTapiSupport ? true, libtapi
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
  version = "949.0.1";

  src = fetchFromGitHub {
    owner  = "tpoechtrager";
    repo   = "cctools-port";
    rev    = "43f32a4c61b5ba7fde011e816136c550b1b3146f";
    sha256 = "10yc5smiczzm62q6ijqccc58bwmfhc897f3bwa5i9j98csqsjj0k";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ autoconf automake libtool autoreconfHook installShellFiles ];
  buildInputs = [ libuuid ]
    ++ lib.optionals stdenv.isDarwin [ libobjc ]
    ++ lib.optional enableTapiSupport libtapi;

  patches = [ ./ld-ignore-rpath-link.patch ./ld-rpath-nonfinal.patch ];

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

    substituteInPlace cctools/include/Makefile \
      --replace "/bin/" ""

    patchShebangs tools
    sed -i -e 's/which/type -P/' tools/*.sh

    # Workaround for https://www.sourceware.org/bugzilla/show_bug.cgi?id=11157
    cat > cctools/include/unistd.h <<EOF
    #ifdef __block
    #  undef __block
    #  include_next "unistd.h"
    #  define __block __attribute__((__blocks__(byref)))
    #else
    #  include_next "unistd.h"
    #endif
    EOF

    cd cctools
  '';

  preInstall = ''
    pushd include
    make DSTROOT=$out/include RC_OS=common install
    popd

    installManPage ar/ar.{1,5}
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
