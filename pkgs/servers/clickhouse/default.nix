{ stdenv, fetchFromGitHub, cmake, libtool
, boost, capnproto, cctz, clang-unwrapped, double-conversion, gperftools, icu
, libcpuid, libxml2, lld, llvm, lz4 , mysql, openssl, poco, re2, rdkafka
, readline, sparsehash, unixODBC, zstd, ninja, jemalloc
}:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";
  version = "18.12.17";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "0gkad6x6jlih30wal8nilhfqr3z22dzgz6m22pza3bhaba2ikk53";
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
  hardeningDisable = [ "format" ];

  patchPhase = ''
    patchShebangs .
  '';

  postInstall = ''
    rm -rf $out/share/clickhouse-test
  '';

  meta = with stdenv.lib; {
    homepage = https://clickhouse.yandex/;
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
