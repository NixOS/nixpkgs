{ stdenv, fetchFromGitHub, cmake, libtool
, boost, capnproto, cctz, clang-unwrapped, double-conversion, gperftools, icu
, libcpuid, libxml2, lld, llvm, lz4 , mysql, openssl, poco, re2, rdkafka
, readline, sparsehash, unixODBC, zstd, ninja
}:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";
  version = "18.5.1";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "1bw1hx3ssd1jcg6jj85nmp6dnyhvaaphjpcr6x4xs410k140qx31";
  };

  nativeBuildInputs = [ cmake libtool ninja ];
  buildInputs = [
    boost capnproto cctz clang-unwrapped double-conversion gperftools icu
    libcpuid libxml2 lld llvm lz4 mysql.connector-c openssl poco re2 rdkafka
    readline sparsehash unixODBC zstd
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DUNBUNDLED=ON"
    "-DUSE_STATIC_LIBRARIES=OFF"
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
