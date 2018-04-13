{ stdenv, fetchFromGitHub, makeWrapper, autoconf, automake, libtool_2
, llvm, libcxx, libcxxabi, clang, libuuid
, libobjc ? null, maloader ? null, xctoolchain ? null
, hostPlatform, targetPlatform
, enableDumpNormalizedLibArgs ? false
}:

let
  # The targetPrefix prepended to binary names to allow multiple binuntils on the
  # PATH to both be usable.
  targetPrefix = stdenv.lib.optionalString
    (targetPlatform != hostPlatform)
    "${targetPlatform.config}-";
in

# Non-Darwin alternatives
assert (!hostPlatform.isDarwin) -> (maloader != null && xctoolchain != null);

let
  baseParams = rec {
    name = "${targetPrefix}cctools-port-${version}";
    version = "895";

    src = fetchFromGitHub (if enableDumpNormalizedLibArgs then {
      owner  = "tpoechtrager";
      repo   = "cctools-port";
      # master with https://github.com/tpoechtrager/cctools-port/pull/34
      rev    = "8395d4b2c3350356e2fb02f5e04f4f463c7388df";
      sha256 = "10vbf1cfzx02q8chc77s84fp2kydjpx2y682mr6mrbb7sq5rwh8f";
    } else {
      owner  = "tpoechtrager";
      repo   = "cctools-port";
      rev    = "2e569d765440b8cd6414a695637617521aa2375b"; # From branch 895-ld64-274.2
      sha256 = "0l45mvyags56jfi24rawms8j2ihbc45mq7v13pkrrwppghqrdn52";
    });

    outputs = [ "out" "dev" ];

    nativeBuildInputs = [ autoconf automake libtool_2 ];
    buildInputs = [ libuuid ] ++
      # Only need llvm and clang if the stdenv isn't already clang-based (TODO: just make a stdenv.cc.isClang)
      stdenv.lib.optionals (!stdenv.isDarwin) [ llvm clang ] ++
      stdenv.lib.optionals stdenv.isDarwin [ libcxxabi libobjc ];

    patches = [
      ./ld-rpath-nonfinal.patch ./ld-ignore-rpath-link.patch
    ];

    __propagatedImpureHostDeps = [
      # As far as I can tell, otool from cctools is the only thing that depends on these two, and we should fix them
      "/usr/lib/libobjc.A.dylib"
      "/usr/lib/libobjc.dylib"
    ];

    enableParallelBuilding = true;

    # TODO(@Ericson2314): Always pass "--target" and always targetPrefix.
    configurePlatforms = [ "build" "host" ] ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";
    configureFlags = stdenv.lib.optionals (!stdenv.isDarwin) [
      "CXXFLAGS=-I${libcxx}/include/c++/v1"
    ];

    postPatch = ''
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
    '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
      sed -i -e 's|clang++|& -I${libcxx}/include/c++/v1|' cctools/autogen.sh
    '';

    # TODO: this builds an ld without support for LLVM's LTO. We need to teach it, but that's rather
    # hairy to handle during bootstrap. Perhaps it could be optional?
    preConfigure = ''
      cd cctools
      sh autogen.sh
    '';

    preInstall = ''
      pushd include
      make DSTROOT=$out/include RC_OS=common install
      popd
    '';

    postInstall =
      if hostPlatform.isDarwin
      then ''
        cat >$out/bin/dsymutil << EOF
        #!${stdenv.shell}
        EOF
        chmod +x $out/bin/dsymutil
      ''
      else ''
        for tool in dyldinfo dwarfdump dsymutil; do
          ${makeWrapper}/bin/makeWrapper "${maloader}/bin/ld-mac" "$out/bin/${targetPlatform.config}-$tool" \
            --add-flags "${xctoolchain}/bin/$tool"
          ln -s "$out/bin/${targetPlatform.config}-$tool" "$out/bin/$tool"
        done
      '';

    passthru = {
      inherit targetPrefix;
    };

    meta = {
      broken = !targetPlatform.isDarwin; # Only supports darwin targets
      homepage = http://www.opensource.apple.com/source/cctools/;
      description = "MacOS Compiler Tools (cross-platform port)";
      license = stdenv.lib.licenses.apsl20;
    };
  };
in stdenv.mkDerivation baseParams
