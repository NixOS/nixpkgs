{
  stdenv,
  fetchgit,
  fetchpatch,
  python3Packages,
  pkgconfig,
  perl,
  stow,
  boost,
  icu,
  fmt,
  c-ares,
  libtasn1,
  xxHash,
  lua5_3,
  rapidjson,
  libunistring,
  p11-kit,
  git,
  systemd,
  gnutls,
  cmake,
  makeWrapper,
  ninja,
  ragel,
  hwloc,
  jsoncpp,
  antlr3,
  numactl,
  protobuf,
  cryptopp,
  libxfs,
  libyamlcpp,
  libsystemtap,
  lksctp-tools,
  lz4,
  libxml2,
  zlib,
  libpciaccess,
  snappy,
  libtool,
  thrift
}:
stdenv.mkDerivation rec {
  pname = "scylladb";
  version = "4.1.8";

  src = fetchgit {
    url = "https://github.com/scylladb/scylla.git";
    rev = "scylla-${version}";
    sha256 = "1iwbqkc7q2yw345z1vvxskkjvdn0g2sp633fk0jcbgjdh6mf3cq2";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/scylladb/scylla/commit/afd0641cc9a3b681c0a5484a182836e0c7902e77.patch";
      sha256 = "0in6qs7achn52yd05jal69bpbb4wqzngmha8d0bdshjsfdcvfi8p";
    })
  ];

  nativeBuildInputs = [
   pkgconfig
   perl
   git
   stow
   cmake
   makeWrapper
   ninja
   antlr3
   python3Packages.pyparsing
  ];

  buildInputs = [
   boost
   icu
   fmt
   c-ares
   hwloc
   p11-kit
   libtasn1
   xxHash
   lua5_3
   rapidjson
   libunistring
   systemd
   gnutls
   ragel
   jsoncpp
   numactl
   protobuf
   cryptopp
   libxfs
   libyamlcpp
   libsystemtap
   lksctp-tools
   lz4
   libxml2
   zlib
   libpciaccess
   snappy
   libtool
   thrift
  ];

  configurePhase = ''
    echo -e '#!/bin/sh\ncat $NIX_CC/nix-support/dynamic-linker' > reloc/get-dynamic-linker.sh

    patchShebangs --build .

    ./configure.py --enable-dpdk --mode=release
  '';

  installPhase = ''
    install -D -m555 -t $out/bin/scylla build/release/scylla
    install -D -m555 -t $out/bin/iotune build/release/iotune
    cp -r dist/common/scripts $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "NoSQL data store using the seastar framework, compatible with Apache Cassandra";
    homepage = "https://scylladb.com";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.farlion ];
  };
}
