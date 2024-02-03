{ maven, lib, fetchFromGitHub }:

maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pacmx5w1VVWz3HmHO6sc2friNUpzo4zyJI1/TQgCXlc=";
  };

  mvnHash = "sha256-RjERY434UL9z/gNZFV+wMTITCmTPGanwu61L8sEGaKY=";

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
