{ stdenv, fetchFromGitHub, cmake, libtool, boost, double_conversion, gperftools, icu, libmysql, lz4, openssl, poco, re2, rdkafka, readline, sparsehash, unixODBC, zookeeper_mt, zstd }:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";

  version = "1.1.54310";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "ClickHouse";
    rev = "v${version}-stable";
    sha256 = "167pihqak8ip7bmlyrbzl9x3mpn381j8v7pl7nhrl9bfnzgrq69v";
  };

  patches = [ ./termcap.patch ];

  nativeBuildInputs = [ cmake libtool ];

  buildInputs = [ boost double_conversion gperftools icu libmysql lz4 openssl poco re2 rdkafka readline sparsehash unixODBC zookeeper_mt zstd ];

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
