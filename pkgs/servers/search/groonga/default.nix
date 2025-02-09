{ lib, stdenv, cmake, fetchurl, kytea, msgpack-c, mecab, pkg-config, rapidjson, testers, xxHash, zstd, postgresqlPackages
, suggestSupport ? false, zeromq, libevent, openssl
, lz4Support  ? false, lz4
, zlibSupport ? true, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "groonga";
  version = "13.0.9";

  src = fetchurl {
    url = "https://packages.groonga.org/source/groonga/groonga-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZmeOYwrd1Xvwqq565zOtcDv6heOLVVaF04M1jEtjDO8=";
  };

  patches = [
    ./fix-cmake-install-path.patch
    ./do-not-use-vendored-libraries.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    rapidjson
    xxHash
    zstd
    mecab
    kytea
    msgpack-c
  ] ++ lib.optionals lz4Support [
    lz4
  ] ++ lib.optional zlibSupport [
    zlib
  ] ++ lib.optionals suggestSupport [
    zeromq
    libevent
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString zlibSupport "-I${zlib.dev}/include";

  passthru.tests = {
    inherit (postgresqlPackages) pgroonga;
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "groonga" ];
    };
  };

  meta = with lib; {
    homepage = "https://groonga.org/";
    description = "An open-source fulltext search engine and column store";
    license = licenses.lgpl21;
    maintainers = [ maintainers.ericsagnes ];
    platforms = platforms.all;
    longDescription = ''
      Groonga is an open-source fulltext search engine and column store.
      It lets you write high-performance applications that requires fulltext search.
    '';
  };
})
