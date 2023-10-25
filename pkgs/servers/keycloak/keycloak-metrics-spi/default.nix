{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "keycloak-metrics-spi";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/aerogear/keycloak-metrics-spi/releases/download/${version}/keycloak-metrics-spi-${version}.jar";
    sha256 = "sha256-D0NNBuc9YBiywGoq5hG4dcoiunyG/C2ZX73p4lS5v4s=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    install "$src" "$out"
  '';

  meta = with lib; {
    homepage = "https://github.com/aerogear/keycloak-metrics-spi";
    description = "Keycloak Service Provider that adds a metrics endpoint";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
