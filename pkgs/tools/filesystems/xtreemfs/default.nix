{ stdenv, boost, fuse, openssl, cmake, attr, jdk, ant, which, file, python
, lib, valgrind, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    # using unstable release because stable (v1.5.1) has broken repl java plugin
    rev = "7ddcb081aa125b0cfb008dc98addd260b8353ab3";
    owner = "xtreemfs";
    repo = "xtreemfs";
    sha256 = "1hjmd32pla27zf98ghzz6r5ml8ry86m9dsryv1z01kxv5l95b3m0";
  };

  pname = "XtreemFS";
  version = "1.5.1.81";

  buildInputs = [ which attr makeWrapper python ];

  preConfigure = ''
    export JAVA_HOME=${jdk}
    export ANT_HOME=${ant}

    export BOOST_INCLUDEDIR=${boost.dev}/include
    export BOOST_LIBRARYDIR=${boost.out}/lib
    export CMAKE_INCLUDE_PATH=${openssl.dev}/include
    export CMAKE_LIBRARY_PATH=${openssl.out}/lib

    substituteInPlace cpp/cmake/FindValgrind.cmake \
      --replace "/usr/local" "${valgrind}"

    substituteInPlace cpp/CMakeLists.txt \
      --replace '"/lib64" "/usr/lib64"' '"${attr.out}/lib" "${fuse}/lib"'

    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${fuse}/include"
    export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -L${fuse}/lib"

    export DESTDIR=$out

    substituteInPlace Makefile \
      --replace "/usr/share/" "/share/" \
      --replace 'BIN_DIR=$(DESTDIR)/usr/bin' "BIN_DIR=$out/bin"

    substituteInPlace etc/init.d/generate_initd_scripts.sh \
      --replace "/bin/bash" "${stdenv.shell}"

    substituteInPlace cpp/thirdparty/gtest-1.7.0/configure \
      --replace "/usr/bin/file" "${file}/bin/file"

    substituteInPlace cpp/thirdparty/protobuf-2.5.0/configure \
      --replace "/usr/bin/file" "${file}/bin/file"

    substituteInPlace cpp/thirdparty/protobuf-2.5.0/gtest/configure \
      --replace "/usr/bin/file" "${file}/bin/file"

    # do not put cmake into buildInputs
    export PATH="$PATH:${cmake}/bin"
  '';

  doCheck = false;

  postInstall = ''
    rm -r $out/sbin
  '';

  meta = {
    description = "A distributed filesystem";
    maintainers = with lib.maintainers; [ raskin matejc ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
