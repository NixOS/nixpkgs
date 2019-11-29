{ stdenv, fetchFromGitHub, cmake, libtool, ninja
, boost, brotli, capnproto, cctz, clang-unwrapped, double-conversion, gperftools
, icu, jemalloc, libcpuid, libxml2, lld, llvm, lz4, libmysqlclient, openssl
, poco, protobuf, rapidjson, re2, rdkafka, readline, sparsehash, unixODBC
, xxHash, zstd
}:

stdenv.mkDerivation rec {
  pname = "clickhouse";
  version = "19.13.6.51";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "0mcwfam1nrs2g54syw7vvpfkjn3l4gfzvla7xbg92lr03fn6kbn2";
  };

  nativeBuildInputs = [ cmake libtool ninja ];
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
