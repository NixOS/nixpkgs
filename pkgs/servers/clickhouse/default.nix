{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, libtool, lldClang, ninja
, boost, brotli, capnproto, cctz, clang-unwrapped, double-conversion
, icu, jemalloc, libcpuid, libxml2, lld, llvm, lz4, libmysqlclient, openssl, perl
, poco, protobuf, python3, rapidjson, re2, rdkafka, readline, sparsehash, unixODBC
, xxHash, zstd
}:

stdenv.mkDerivation rec {
  pname = "clickhouse";
  version = "20.11.4.13";

  src = fetchFromGitHub {
    owner  = "ClickHouse";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    fetchSubmodules = true;
    sha256 = "0c87k0xqwj9sc3xy2f3ngfszgjiz4rzd787bdg6fxp94w1adjhny";
  };

  nativeBuildInputs = [ cmake libtool lldClang.bintools ninja ];
  buildInputs = [
    boost brotli capnproto cctz clang-unwrapped double-conversion
    icu jemalloc libcpuid libxml2 lld llvm lz4 libmysqlclient openssl perl
    poco protobuf python3 rapidjson re2 rdkafka readline sparsehash unixODBC
    xxHash zstd
  ];

  patches = [
    # This patch is only required for 20.11.4.13 - it should be included in the
    # next stable release from upstream by default
    (fetchpatch {
      url = "https://github.com/ClickHouse/ClickHouse/commit/e31753b4db7aa0a72a85757dc11fc403962e30db.patch";
      sha256 = "12ax02dh9y9k8smkj6v50yfr46iprscbrvd4bb9vfbx8xqgw7grb";
    })
  ];

  postPatch = ''
    patchShebangs src/

    substituteInPlace contrib/openssl-cmake/CMakeLists.txt \
      --replace '/usr/bin/env perl' perl
    substituteInPlace src/Storages/System/StorageSystemLicenses.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-duplicate-includes.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-ungrouped-includes.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/generate-ya-make/generate-ya-make.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/list-licenses/list-licenses.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-style \
      --replace 'git rev-parse --show-toplevel' '$src'
  '';

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
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

  meta = with lib; {
    homepage = "https://clickhouse.tech/";
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
