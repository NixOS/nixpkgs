{ lib, stdenv, fetchFromGitHub, cmake, libtool, llvm-bintools, ninja
, boost, brotli, capnproto, cctz, clang-unwrapped, double-conversion
, icu, jemalloc, libcpuid, libxml2, lld, llvm, lz4, libmysqlclient, openssl, perl
, poco, protobuf, python3, rapidjson, re2, rdkafka, readline, sparsehash, unixODBC
, xxHash, zstd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "clickhouse";
  version = "22.8.11.15";

  broken = stdenv.buildPlatform.is32bit; # not supposed to work on 32-bit https://github.com/ClickHouse/ClickHouse/pull/23959#issuecomment-835343685

  src = fetchFromGitHub {
    owner  = "ClickHouse";
    repo   = "ClickHouse";
    rev    = "v${version}-lts";
    fetchSubmodules = true;
    sha256 = "sha256-ZFS7RgeTV/eMSiI0o9WO1fHjRkPDNZs0Gm3w+blGsz0=";
  };

  nativeBuildInputs = [ cmake libtool llvm-bintools ninja ];
  buildInputs = [
    boost brotli capnproto cctz clang-unwrapped double-conversion
    icu jemalloc libxml2 lld llvm lz4 libmysqlclient openssl perl
    poco protobuf python3 rapidjson re2 rdkafka readline sparsehash unixODBC
    xxHash zstd
  ] ++ lib.optional stdenv.hostPlatform.isx86 libcpuid;

  postPatch = ''
    patchShebangs src/

    substituteInPlace src/Storages/System/StorageSystemLicenses.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-duplicate-includes.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-ungrouped-includes.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/list-licenses/list-licenses.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-style \
      --replace 'git rev-parse --show-toplevel' '$src'
  '';

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_CCACHE=0"
    "-DENABLE_EMBEDDED_COMPILER=ON"
    "-USE_INTERNAL_LLVM_LIBRARY=OFF"
  ];

  postInstall = ''
    rm -rf $out/share/clickhouse-test

    sed -i -e '\!<log>/var/log/clickhouse-server/clickhouse-server\.log</log>!d' \
      $out/etc/clickhouse-server/config.xml
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace "<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>" "<console>1</console>"
  '';

  hardeningDisable = [ "format" ];

  # Builds in 7+h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests.clickhouse = nixosTests.clickhouse;

  meta = with lib; {
    homepage = "https://clickhouse.com";
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
