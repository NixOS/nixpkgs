{ stdenv, fetchFromGitHub, autoconf, automake, libtool, autoreconfHook
, libcxxabi, libuuid, llvm
, libobjc ? null, maloader ? null
}:

let

  # The targetPrefix prepended to binary names to allow multiple binuntils on the
  # PATH to both be usable.
  targetPrefix = stdenv.lib.optionalString
    (stdenv.targetPlatform != stdenv.hostPlatform)
    "${stdenv.targetPlatform.config}-";
in

# Non-Darwin alternatives
assert (!stdenv.hostPlatform.isDarwin) -> maloader != null;

let
  baseParams = rec {
    name = "${targetPrefix}cctools-port-${version}";
    version = "895";

    src = fetchFromGitHub {
      owner  = "tpoechtrager";
      repo   = "cctools-port";
      rev    = "07619027f8311fa61b4a549c75994b88739a82d8";
      sha256 = "12g94hhz5v5bmy2w0zb6fb4bjlmn992gygc60h9nai15kshj2spi";
    };

    outputs = [ "out" "dev" ];

    nativeBuildInputs = [ autoconf automake libtool autoreconfHook ];
    buildInputs = [ libuuid ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ libcxxabi libobjc ];

    patches = [ ./ld-rpath-nonfinal.patch ./ld-ignore-rpath-link.patch ];

    __propagatedImpureHostDeps = [
      # As far as I can tell, otool from cctools is the only thing that depends on these two, and we should fix them
      "/usr/lib/libobjc.A.dylib"
      "/usr/lib/libobjc.dylib"
    ];

    enableParallelBuilding = true;

    # TODO(@Ericson2314): Always pass "--target" and always targetPrefix.
    configurePlatforms = [ "build" "host" ]
      ++ stdenv.lib.optional (stdenv.targetPlatform != stdenv.hostPlatform) "target";
    configureFlags = [ "--disable-clang-as" ];

    postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
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

    # TODO: this builds an ld without support for LLVM's LTO. We need to teach it, but that's rather
    # hairy to handle during bootstrap. Perhaps it could be optional?
    preConfigure = ''
      sh autogen.sh
    '';

    preInstall = ''
      pushd include
      make DSTROOT=$out/include RC_OS=common install
      popd
    '';

    passthru = {
      inherit targetPrefix;
    };

    meta = {
      broken = !stdenv.targetPlatform.isDarwin; # Only supports darwin targets
      homepage = http://www.opensource.apple.com/source/cctools/;
      description = "MacOS Compiler Tools (cross-platform port)";
      license = stdenv.lib.licenses.apsl20;
    };
  };
in stdenv.mkDerivation baseParams
