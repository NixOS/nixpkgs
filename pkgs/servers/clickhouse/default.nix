{ stdenv, fetchFromGitHub, cmake, libtool, boost, cctz, double-conversion, gperftools
, icu, lz4, mysql, openssl, poco, re2, rdkafka, readline, sparsehash, unixODBC, zstd
}:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";

  version = "1.1.54385";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "ClickHouse";
    rev = "v${version}-stable";
    sha256 = "0s290xnx9dil2lbxdir5p5zmakvq5h523gdwax2cb37606wg8yj7";
  };

  patches = [ ./find-mysql.patch ./termcap.patch ];

  nativeBuildInputs = [ cmake libtool ];

  buildInputs = [
    boost cctz double-conversion gperftools icu lz4 mysql.connector-c openssl poco
    re2 rdkafka readline sparsehash unixODBC zstd
  ];

  cmakeFlags = [ "-DENABLE_TESTS=OFF" "-DUNBUNDLED=ON" "-DUSE_STATIC_LIBRARIES=OFF" ];

  meta = with stdenv.lib; {
    homepage = https://clickhouse.yandex/;
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
