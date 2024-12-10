{
  abseil-cpp_202206,
  avro-cpp,
  callPackage,
  ccache,
  cmake,
  crc32c,
  croaring,
  ctre,
  curl,
  dpdk,
  git,
  lib,
  llvmPackages_14,
  llvm_14,
  ninja,
  p11-kit,
  pkg-config,
  procps,
  protobuf_21,
  python3,
  snappy,
  src,
  unzip,
  version,
  writeShellScriptBin,
  xxHash,
  zip,
  zstd,
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
in
llvmPackages_14.stdenv.mkDerivation rec {
  inherit pname version src;

  preConfigure = ''
    # setup sccache
    export CCACHE_DIR=$TMPDIR/sccache-redpanda
    mkdir -p $CCACHE_DIR
  '';
  patches = [
    ./redpanda.patch
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
    llvm_14
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
  ];

  buildInputs = [
    abseil-cpp_202206
    avro-cpp
    base64
    crc32c
    croaring
    ctre
    dpdk
    hdr-histogram
    p11-kit
    protobuf_21
    rapidjson
    seastar
    snappy
    xxHash
    zstd
  ];

  meta = with lib; {
    broken = true;
    description = "Kafka-compatible streaming platform.";
    license = licenses.bsl11;
    longDescription = ''
      Redpanda is a Kafka-compatible streaming data platform that is
      proven to be 10x faster and 6x lower in total costs. It is also JVM-free,
      ZooKeeper-free, Jepsen-tested and source available.
    '';
    homepage = "https://redpanda.com/";
    maintainers = with maintainers; [
      avakhrenev
      happysalada
    ];
    platforms = platforms.linux;
  };
}
