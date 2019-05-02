{ stdenv, fetchFromGitHub, fetchpatch, cmake, libtool
, boost, capnproto, cctz, clang-unwrapped, double-conversion, gperftools, icu
, libcpuid, libxml2, lld, llvm, lz4 , mysql, openssl, poco, re2, rdkafka
, readline, sparsehash, unixODBC, zstd, ninja, jemalloc
}:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";
  version = "18.16.1";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "02slllcan7w3ln4c9yvxc8w0h2vszd7n0wshbn4bra2hb6mrzyp8";
  };

  nativeBuildInputs = [ cmake libtool ninja ];
  buildInputs = [
    boost capnproto cctz clang-unwrapped double-conversion gperftools icu
    libcpuid libxml2 lld llvm lz4 mysql.connector-c openssl poco re2 rdkafka
    readline sparsehash unixODBC zstd jemalloc
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DUNBUNDLED=ON"
    "-DUSE_STATIC_LIBRARIES=OFF"
    "-DUSE_INTERNAL_SSL_LIBRARY=False"
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/yandex/ClickHouse/commit/afbcdf2f00a04e747c5279414cf4691f29bb5cc2.patch";
      sha256 = "17y891q0dp179w3jv32h74pbfwyzgnz4dxxwv73vzdwvys4i8c8z";
    })
  ];

  postPatch = ''
    patchShebangs copy_headers.sh
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
