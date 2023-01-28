{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtls, sqlite }:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanomq";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = finalAttrs.version;
    hash = "sha256-h4TCorZfg9Sin4CZPRifUkqeg4F2V1DluolerSeREs4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION /etc" "DESTINATION $out/etc"
  '';

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ mbedtls sqlite ];

  cmakeFlags = [
    "-DBUILD_NANOMQ_CLI=ON"
    "-DNNG_ENABLE_TLS=ON"
    "-DNNG_ENABLE_SQLITE=ON"
  ];

  meta = with lib; {
    description = "An ultra-lightweight and blazing-fast MQTT broker for IoT edge";
    homepage = "https://nanomq.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
