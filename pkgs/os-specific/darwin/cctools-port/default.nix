{ stdenv, cross, fetchurl, autoconf, automake, libtool
, libcxx, llvm, clang, openssl, libuuid
, maloader, makeWrapper, xctoolchain
}:

stdenv.mkDerivation rec {
  name = "cctools-port-${version}";
  version = "845";

  src = fetchurl {
    url = "https://github.com/tpoechtrager/cctools-port/archive/"
        + "cctools-${version}-ld64-136-1.tar.gz";
    sha256 = "06pg6h1g8avgx4j6cfykdpggf490li796gzhhyqn27jsagli307i";
  };

  buildInputs = [
    autoconf automake libtool libcxx llvm clang openssl libuuid makeWrapper
  ];

  patches = [ ./ld-rpath-nonfinal.patch ./ld-ignore-rpath-link.patch ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs tools
    sed -i -e 's/which/type -P/' tools/*.sh
    sed -i -e 's|clang++|& -I${libcxx}/include/c++/v1|' cctools/autogen.sh

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

  configureFlags = [
    "CXXFLAGS=-I${libcxx}/include/c++/v1"
    "--target=${cross.config}"
  ];

  postInstall = ''
    for tool in dyldinfo dwarfdump dsymutil; do
      makeWrapper "${maloader}/bin/ld-mac" "$out/bin/${cross.config}-$tool" \
        --add-flags "${xctoolchain}/bin/$tool"
      ln -s "$out/bin/${cross.config}-$tool" "$out/bin/$tool"
    done
  '';

  meta = {
    homepage = "http://www.opensource.apple.com/source/cctools/";
    description = "Mac OS X Compiler Tools (cross-platform port)";
    license = stdenv.lib.licenses.apsl20;
  };
}
