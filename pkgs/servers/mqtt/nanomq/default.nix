{ lib, stdenv, fetchFromGitHub, cmake, ninja, pkg-config
, cyclonedds, libmysqlclient, mariadb, mbedtls, sqlite, zeromq
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanomq";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = finalAttrs.version;
    hash = "sha256-9w4afVxuJbYrkagpAe1diftDnjrRjunyhJdJ0BZq3K0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION /etc" "DESTINATION $out/etc"
  '';

  nativeBuildInputs = [ cmake ninja pkg-config ];

  buildInputs = [ cyclonedds libmysqlclient mariadb mbedtls sqlite zeromq ];

  cmakeFlags = [
    "-DBUILD_BENCH=ON"
    "-DBUILD_DDS_PROXY=ON"
    "-DBUILD_NANOMQ_CLI=ON"
    "-DBUILD_ZMQ_GATEWAY=ON"
    "-DENABLE_RULE_ENGINE=ON"
    "-DNNG_ENABLE_SQLITE=ON"
    "-DNNG_ENABLE_TLS=ON"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-return-type";

  meta = with lib; {
    description = "An ultra-lightweight and blazing-fast MQTT broker for IoT edge";
    homepage = "https://nanomq.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
