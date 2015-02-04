{ stdenv, fetchurl, autoconf, automake, libtool
, llvm, libcxx, clang, openssl, libuuid
}:

let
  baseParams = rec {
    name = "cctools-port-${version}";
    version = "855";

    src = let
      # Should be fetchFromGitHub but it was whining so this will do for now
      owner  = "tpoechtrager";
      repo   = "cctools-port";
      rev    = "7083dddbb0f106d791d313829ea7dc45db90e375";
    in fetchurl {
      url    = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      sha256 = "017gxlcwgi7xhayjzj9w3fac175p2rm4vjzf9cycq9683m9pmyzj";
    };

    buildInputs = [
      autoconf automake libtool llvm clang openssl libuuid libcxx
    ];

    patches = [ ./ld-rpath-nonfinal.patch ./ld-ignore-rpath-link.patch ];

    enableParallelBuilding = true;

    postPatch = ''
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
    '';

    preConfigure = ''
      cd cctools
      sh autogen.sh
    '';

    meta = {
      homepage = "http://www.opensource.apple.com/source/cctools/";
      description = "Mac OS X Compiler Tools (cross-platform port)";
      license = stdenv.lib.licenses.apsl20;
    };
  };
in {
  # Hacks that for the darwin stdenv (sad that we need write workarounds for what started as a darwin package)
  native = stdenv.mkDerivation (baseParams // {
    patches = baseParams.patches ++ [ ./darwin.patch ];

    postInstall = ''
      cd $out/bin
      for tool in dwarfdump dsymutil; do
        ln -s /usr/bin/$tool
      done
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
