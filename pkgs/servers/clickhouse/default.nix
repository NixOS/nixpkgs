{ stdenv, fetchFromGitHub, cmake, libtool
, boost, capnproto, cctz, clang-unwrapped, double-conversion, gperftools, icu
, libcpuid, libxml2, lld, llvm, lz4 , mysql, openssl, poco, re2, rdkafka
, readline, sparsehash, unixODBC, zstd, ninja, jemalloc, brotli, protobuf, xxHash
}:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";
  version = "19.13.2.19";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "1zivksmadw8srszvkhycgp528j7m1s47i29k603v0azg5213qnmj";
  };

  nativeBuildInputs = [ cmake libtool ninja ];
  buildInputs = [
    boost capnproto cctz clang-unwrapped double-conversion gperftools icu
    libcpuid libxml2 lld llvm lz4 mysql.connector-c openssl poco re2 rdkafka
    readline sparsehash unixODBC zstd jemalloc brotli protobuf xxHash
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
