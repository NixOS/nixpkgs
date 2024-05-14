{
  maven,
  lib,
  fetchFromGitHub,
}:
let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iagXbsKsU4vNP9eg05bwXEo67iij3N2FF0BW50MjRGE=";
  };

  mvnHash = selectSystem {
    x86_64-linux = "sha256-+ySBrQ9yQ5ZxuVUh/mnHNEmugru3n8x5VR/RYEDCLAo=";
    aarch64-linux = "sha256-zO79pRrY8TqrSK4bB8l4pl6834aFX2pidyk1j9Itz1E=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-metrics-spi-*.jar
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/aerogear/keycloak-metrics-spi";
    description = "Keycloak Service Provider that adds a metrics endpoint";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
