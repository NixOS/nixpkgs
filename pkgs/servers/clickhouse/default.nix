{ stdenv, fetchFromGitHub, cmake, libtool, boost, double_conversion, gperftools, icu, libmysql, lz4, openssl, poco, re2, readline, sparsehash, unixODBC, zookeeper_mt, zstd }:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";

  version = "1.1.54236";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "ClickHouse";
    rev = "v${version}-stable";
    sha256 = "1mfjr1yzvf810vbb35c2rknvqnc4mkncl56ja48myn7hc9p457d7";
  };

  patches = [ ./termcap.patch ];

  nativeBuildInputs = [ cmake libtool ];

  buildInputs = [ boost double_conversion gperftools icu libmysql lz4 openssl poco re2 readline sparsehash unixODBC zookeeper_mt zstd ];

  cmakeFlags = [ "-DENABLE_TESTS=OFF" "-DUNBUNDLED=ON" "-DUSE_STATIC_LIBRARIES=OFF" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=unused-function" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://clickhouse.yandex/;
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
