{ stdenv, fetchFromGitHub, cmake, libtool, lldClang, ninja
, boost, brotli, capnproto, cctz, clang-unwrapped, double-conversion, gperftools
, icu, jemalloc, libcpuid, libxml2, lld, llvm, lz4, libmysqlclient, openssl
, poco, protobuf, rapidjson, re2, rdkafka, readline, sparsehash, unixODBC
, xxHash, zstd
}:

stdenv.mkDerivation rec {
  pname = "clickhouse";
  version = "19.17.8.54";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "0ck6kcifj7y4i2j1jj1a9vf5nfpp9mxk5x8y8557zp9yayjm9qyr";
  };

  nativeBuildInputs = [ cmake libtool lldClang.bintools ninja ];
  buildInputs = [
    boost brotli capnproto cctz clang-unwrapped double-conversion gperftools
    icu jemalloc libcpuid libxml2 lld llvm lz4 libmysqlclient openssl
    poco protobuf rapidjson re2 rdkafka readline sparsehash unixODBC
    xxHash zstd
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DUNBUNDLED=ON"
    "-DUSE_STATIC_LIBRARIES=OFF"
  ];

  postPatch = ''
    patchShebangs dbms/programs/clang/copy_headers.sh
  '';

  postInstall = ''
    rm -rf $out/share/clickhouse-test

    sed -i -e '\!<log>/var/log/clickhouse-server/clickhouse-server\.log</log>!d' \
      $out/etc/clickhouse-server/config.xml
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace "<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>" "<console>1</console>"
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://clickhouse.yandex/;
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
