{ stdenv, fetchFromGitHub, cmake, libtool
, boost, capnproto, cctz, clang-unwrapped, double-conversion, gperftools, icu
, libcpuid, libxml2, lld, llvm, lz4 , mysql, openssl, poco, re2, rdkafka
, readline, sparsehash, unixODBC, zstd
}:

stdenv.mkDerivation rec {
  name = "clickhouse-${version}";

  version = "18.1.0";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "ClickHouse";
    rev = "v${version}-stable";
    sha256 = "1vsfnggf69xh91ndycdxwfz6m2bs7psaxf2bh04svgk1vzj2z4l0";
  };

  nativeBuildInputs = [ cmake libtool ];

  buildInputs = [
    boost capnproto cctz clang-unwrapped double-conversion gperftools icu
    libcpuid libxml2 lld llvm lz4 mysql.connector-c openssl poco re2 rdkafka
    readline sparsehash unixODBC zstd
  ];

  cmakeFlags = [ "-DENABLE_TESTS=OFF" "-DUNBUNDLED=ON" "-DUSE_STATIC_LIBRARIES=OFF" ];

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
