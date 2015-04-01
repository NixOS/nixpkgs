{ stdenv, fetchurl, autoconf, automake, libtool
, llvm, libcxx, libcxxabi, clang, openssl, libuuid
, libobjc ? null
}:

let
  baseParams = rec {
    name = "cctools-port-${version}";
    version = "862";

    src = let
      # Should be fetchFromGitHub but it was whining so this will do for now
      owner  = "tpoechtrager";
      repo   = "cctools-port";
      rev    = "59d21d2c793c51d205c8b4ab14b9b28e63c72445";
    in fetchurl {
      url    = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      sha256 = "01f31ijpnplbiyp7ldwzy8vbkn3j3m56n5blsvsav5nlp4lp2g71";
    };

    buildInputs = [ autoconf automake libtool openssl libuuid ] ++
      # Only need llvm and clang if the stdenv isn't already clang-based (TODO: just make a stdenv.cc.isClang)
      stdenv.lib.optionals (!stdenv.isDarwin) [ llvm clang ] ++
      stdenv.lib.optionals stdenv.isDarwin [ libcxxabi libobjc ];

    patches = [
      ./ld-rpath-nonfinal.patch ./ld-ignore-rpath-link.patch
    ];

    enableParallelBuilding = true;

    configureFlags = stdenv.lib.optionals (!stdenv.isDarwin) [ "CXXFLAGS=-I${libcxx}/include/c++/v1" ];

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

    preConfigure = ''
      cd cctools
      sh autogen.sh
    '';

    preInstall = ''
      pushd include
      make DSTROOT=$out/include RC_OS=common install
      popd
    '';

    meta = {
      homepage = "http://www.opensource.apple.com/source/cctools/";
      description = "Mac OS X Compiler Tools (cross-platform port)";
      license = stdenv.lib.licenses.apsl20;
    };
  };
in {
  native = stdenv.mkDerivation (baseParams // {
    # A hack for now...
    postInstall = ''
      cat >$out/bin/dsymutil << EOF
      #!${stdenv.shell}
      EOF
      chmod +x $out/bin/dsymutil
    '';
  });

  cross =
    { cross, maloader, makeWrapper, xctoolchain}: stdenv.mkDerivation (baseParams // {
      configureFlags = baseParams.configureFlags ++ [ "--target=${cross.config}" ];

      postInstall = ''
        for tool in dyldinfo dwarfdump dsymutil; do
          ${makeWrapper}/bin/makeWrapper "${maloader}/bin/ld-mac" "$out/bin/${cross.config}-$tool" \
            --add-flags "${xctoolchain}/bin/$tool"
          ln -s "$out/bin/${cross.config}-$tool" "$out/bin/$tool"
        done
      '';
    });
}
