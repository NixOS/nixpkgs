{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, makeWrapper
, stripJavaArchivesHook
, ant
, attr
, boost
, cmake
, file
, fuse
, jdk8
, openssl
, python3
, valgrind
, which
}:

stdenv.mkDerivation {
  pname = "XtreemFS";
  # using unstable release because stable (v1.5.1) has broken repl java plugin
  version = "unstable-2015-06-17";

  src = fetchFromGitHub {
    rev = "7ddcb081aa125b0cfb008dc98addd260b8353ab3";
    owner = "xtreemfs";
    repo = "xtreemfs";
    sha256 = "1hjmd32pla27zf98ghzz6r5ml8ry86m9dsryv1z01kxv5l95b3m0";
  };

  nativeBuildInputs = [ makeWrapper python3 stripJavaArchivesHook ];
  buildInputs = [ which attr ];

  patches = [
    (fetchpatch {
      name = "protobuf-add-arm64-atomicops.patch";
      url = "https://github.com/protocolbuffers/protobuf/commit/2ca19bd8066821a56f193e7fca47139b25c617ad.patch";
      stripLen = 1;
      extraPrefix = "cpp/thirdparty/protobuf-2.5.0/";
      sha256 = "sha256-hlL5ZiJhpO3fPpcSTV+yki4zahg/OhFdIZEGF1TNTe0=";
    })
    (fetchpatch {
      name = "protobuf-add-aarch64-architecture-to-platform-macros.patch";
      url = "https://github.com/protocolbuffers/protobuf/commit/f0b6a5cfeb5f6347c34975446bda08e0c20c9902.patch";
      stripLen = 1;
      extraPrefix = "cpp/thirdparty/protobuf-2.5.0/";
      sha256 = "sha256-VRl303x9g5ES/LMODcAdhsPiEmQTq/qXhE/DfvLXF84=";
    })
    (fetchpatch {
      name = "xtreemfs-fix-for-boost-version-1.66.patch";
      url = "https://github.com/xtreemfs/xtreemfs/commit/aab843cb115ab0739edf7f58fd2d4553a05374a8.patch";
      sha256 = "sha256-y/vXI/PT1TwSy8/73+RKIgKq4pZ9i22MBxr6jo/M5l8=";
    })
    (fetchpatch {
      name = "xtreemfs-fix-for-openssl_1_1.patch";
      url = "https://github.com/xtreemfs/xtreemfs/commit/ebfdc2fff56c09f310159d92026883941e42a953.patch";
      sha256 = "075w00ad88qm6xpm5679m0gfzkrc53w17sk7ycybf4hzxjs29ygy";
    })
  ];

  preConfigure = ''
    export JAVA_HOME=${jdk8}
    export ANT_HOME=${ant}

    export BOOST_INCLUDEDIR=${boost.dev}/include
    export BOOST_LIBRARYDIR=${boost.out}/lib
    export CMAKE_INCLUDE_PATH=${openssl.dev}/include
    export CMAKE_LIBRARY_PATH=${lib.getLib openssl}/lib

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
    description = "Distributed filesystem";
    maintainers = with lib.maintainers; [ raskin matejc ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
