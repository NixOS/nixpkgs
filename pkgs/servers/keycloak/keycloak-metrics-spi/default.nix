{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "keycloak-metrics-spi";
  version = "2.5.3";

  src = fetchurl {
    url = "https://github.com/aerogear/keycloak-metrics-spi/releases/download/${version}/keycloak-metrics-spi-${version}.jar";
    sha256 = "15lsy8wjw6nlfdfhllc45z9l5474p0lsghrwzzsssvd68bw54gwv";
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
    license = licenses.apsl20;
    maintainers = with maintainers; [ benley ];
  };
}
