{ lib, stdenv, fetchFromGitHub, cmake, ninja, mbedtls, sqlite }:

stdenv.mkDerivation rec {
  pname = "nanomq";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = version;
    hash = "sha256-fxV/X34yohh/bxOsnoVngBKiwqABQDthLgZxvomC0+g=";
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
    knownVulnerabilities = [
      "CVE-2023-29994"
      "CVE-2023-29995"
      "CVE-2023-29996"
      "https://github.com/emqx/nanomq/issues/1050"  # not individually assigned CVEs
    ];
  };
}
