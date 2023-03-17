{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, ninja, pkg-config
, cyclonedds, libmysqlclient, mariadb, mbedtls, sqlite, zeromq
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanomq";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = finalAttrs.version;
    hash = "sha256-eIwUsYPpRZMl1oCuuZeOj0SCBHDaJdmdWdoI4yuqxrg=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix the conflict on function naming in ddsproxy
    (fetchpatch {
      url = "https://github.com/emqx/nanomq/commit/20f436a3b9d45f9809d7c7f0714905c657354631.patch";
      hash = "sha256-ISMlf9QW73oogMTlifi/r08uSxBpzRYvBSJBB1hn2xY=";
    })
  ];

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
