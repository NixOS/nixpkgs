{ maven, lib, fetchFromGitHub }:

maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iagXbsKsU4vNP9eg05bwXEo67iij3N2FF0BW50MjRGE=";
  };

  mvnHash = "sha256-+ySBrQ9yQ5ZxuVUh/mnHNEmugru3n8x5VR/RYEDCLAo=";

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
