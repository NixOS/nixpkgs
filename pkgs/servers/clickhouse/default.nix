{ stdenv, fetchFromGitHub, fetchpatch, cmake, libtool, buildPackages
, boost, capnproto, cctz, clang-unwrapped, double-conversion, gperftools, icu
, libcpuid, libxml2, lld, llvm, lz4 , mysql, openssl, poco, re2, rdkafka
, readline, sparsehash, unixODBC, zstd, ninja, jemalloc, brotli, protobuf, xxHash
}:

let
  # can't link c++ libraries built with clang with code built with gcc, so
  # need to ensure these have been built with same compiler
  abiCompat = stdenvA: stdenvB: stdenvA.cc.isGNU == stdenvB.cc.isGNU;
  cctz' = if (abiCompat stdenv cctz.stdenv) then cctz else (cctz.override { inherit stdenv; });
  poco' = if (abiCompat stdenv poco.stdenv) then poco else (poco.override { inherit stdenv; });
  re2' = if (abiCompat stdenv re2.stdenv) then re2 else (re2.override { inherit stdenv; });
  boost' = if (abiCompat stdenv boost.stdenv) then boost else (boost.override {
    inherit stdenv buildPackages;
  });
  # protobuf does a charming double-callPackage, so we wrap the callPackage it
  # is handed, giving it one that injects our extra args into calls
  protobuf' = if (abiCompat stdenv protobuf.stdenv) then protobuf else (protobuf.override (oldAttrs: {
    callPackage = f: cpArgs: oldAttrs.callPackage f (cpArgs // {
      inherit stdenv buildPackages;
    });
  }));
in stdenv.mkDerivation rec {
  name = "clickhouse-${version}";
  version = "19.6.2.11";

  src = fetchFromGitHub {
    owner  = "yandex";
    repo   = "ClickHouse";
    rev    = "v${version}-stable";
    sha256 = "0bs38a8dm5x43klx4nc5dwkkxpab12lp2chyvc2y47c75j7rn5d7";
  };
  patches = stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      name = "darwin-build-fix.patch";
      url = https://github.com/yandex/ClickHouse/commit/10c349e398111b522c20db3852455d067f7d9471.patch;
      sha256 = "1y2c5zprlnlihi9437w3fn6c5dx2vhxhm6165njv6k3j0zmmad9h";
    })
    (fetchpatch {
      name = "darwin-build-fix-2.patch";
      url = https://github.com/yandex/ClickHouse/commit/deddb40bf203bc7ef21b3cb29a858a71992c2937.patch;
      sha256 = "1ax6h46jmb40rc91vh34179c55nh5xj825gdgz4avawpk608y2yw";
    })
  ];

  nativeBuildInputs = [ cmake libtool ninja ];
  buildInputs = [
    gperftools icu capnproto clang-unwrapped double-conversion
    libcpuid libxml2 lld llvm lz4 mysql.connector-c openssl rdkafka
    readline sparsehash unixODBC zstd jemalloc brotli xxHash
    cctz' poco' re2' boost' protobuf'
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
