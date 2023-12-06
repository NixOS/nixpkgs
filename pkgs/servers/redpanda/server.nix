{ stdenv
, abseil-cpp_202206
, avro-cpp
, boost
, callPackage
, ccache
, cmake
, crc32c
, croaring
, ctre
, curl
, dpdk
, git
, lib
, libpthreadstubs
, llvmPackages_15
, libxml2
, ninja
, p11-kit
, pkg-config
, procps
, protobuf_21
, python3
, re2
, snappy
, src
, unzip
, version
, writeShellScriptBin
, xxHash
, zip
, zstd
}:
let
  pname = "redpanda";
  pythonPackages = p: with p; [ jinja2 ];
  seastar = callPackage ./seastar.nix { };
  base64 = callPackage ./base64.nix { };
  hdr-histogram = callPackage ./hdr-histogram.nix { };
  kafka-codegen-venv = python3.withPackages (ps: [
    ps.jinja2
    ps.jsonschema
  ]);
  rapidjson = callPackage ./rapidjson.nix { };
  boost' = boost.override {
    enablePython = true;
    python = python3.withPackages pythonPackages;
  };
in
llvmPackages_15.stdenv.mkDerivation rec {
  inherit pname version src;

  preConfigure = ''
    # setup sccache
    export CCACHE_DIR=$TMPDIR/sccache-redpanda
    mkdir -p $CCACHE_DIR
  '';
  patches = [
    ./redpanda.patch
    ./typename.patch
    ./missing_includes.patch
  ];
  postPatch = ''
    # Fix 'error: use of undeclared identifier 'roaring'; did you mean 'Roaring
    #      qualified reference to 'Roaring' is a constructor name rather than a type in this context'
    substituteInPlace \
        ./src/v/storage/compacted_offset_list.h \
        ./src/v/storage/compaction_reducers.cc \
        ./src/v/storage/compaction_reducers.h \
        ./src/v/storage/segment_utils.h \
        ./src/v/storage/segment_utils.cc \
        --replace 'roaring::Roaring' 'Roaring'

    patchShebangs ./src/v/rpc/rpc_compiler.py
  '';

  doCheck = false;

  nativeBuildInputs = [
    (python3.withPackages pythonPackages)
    (writeShellScriptBin "kafka-codegen-venv" "exec -a $0 ${kafka-codegen-venv}/bin/python3 $@")
    ccache
    cmake
    curl
    git
    llvmPackages_15.llvm
    ninja
    pkg-config
    procps
    seastar
    unzip
    zip
  ];

  cmakeFlags = [
    "-DREDPANDA_DEPS_SKIP_BUILD=ON"
    "-DRP_ENABLE_TESTS=OFF"
    "-Wno-dev"
    "-DGIT_VER=${version}"
    "-DGIT_CLEAN_DIRTY=\"\""

    # fixing 'no member named nullopt in namespace std'
    # "-DCMAKE_CXX_FLAGS=-std=c++20"
    # "-DBASE_CXX_FLAG_LIST=-stdlib=libc++"
    # "-DCMAKE_EXE_LINKER_FLAGS='-lpthread -lc++ -lc++abi' "
  ];
  # preConfigure = ''
    # not sure how to give this argument multiple flags in `cmakeFlags`
    # cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-Wl,-lpthread -Wl,-lc++ -Wl,-lc++abi")
  # '';


  # SEE: https://github.com/NixOS/nixpkgs/issues/12857
  # NIX_LDFLAGS="-lpthread -L${libpthreadstubs}/lib";

  buildInputs = [
    # boost
    # libpthreadstubs
    abseil-cpp_202206
    avro-cpp
    base64
    # boost'
    # boost.dev
    crc32c
    croaring
    ctre
    dpdk
    hdr-histogram
    libxml2
    p11-kit
    protobuf_21
    rapidjson
    re2
    seastar
    snappy
    xxHash
    zstd
  ];

  meta = with lib; {
    # broken = true;
    description = "Kafka-compatible streaming platform.";
    license = licenses.gpl3;
    longDescription = ''
      Redpanda is a Kafka-compatible streaming data platform that is
      proven to be 10x faster and 6x lower in total costs. It is also JVM-free,
      ZooKeeper-free, Jepsen-tested and source available.
    '';
    homepage = "https://redpanda.com/";
    maintainers = with maintainers; [ avakhrenev happysalada ];
    platforms = platforms.linux;
  };
}
