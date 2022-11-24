{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtls, sqlite }:

stdenv.mkDerivation rec {
  pname = "nanomq";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = version;
    hash = "sha256-FJhM1IdS6Ee54JJqJXpvp0OcTJJo2NaB/uP8w3mf/Yw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION /etc" "DESTINATION $out/etc"
  '';

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ mbedtls sqlite ];

  cmakeFlags = [
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
}
