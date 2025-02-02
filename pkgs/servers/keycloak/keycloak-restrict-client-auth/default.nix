{ maven, lib, fetchFromGitHub }:

maven.buildMavenPackage rec {
  pname = "keycloak-restrict-client-auth";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "sventorben";
    repo = "keycloak-restrict-client-auth";
    rev = "v${version}";
    hash = "sha256-Pk0tj8cTHSBwVIzINE7GLA5b/eI97wuOTvO7UoXBStM=";
  };

  mvnHash = "sha256-Pk2yYuBqGs4k1KwaU06RQe1LpohZu0VI1pHEUBU3EUE=";

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-restrict-client-auth.jar
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/sventorben/keycloak-restrict-client-auth";
    description = "A Keycloak authenticator to restrict authorization on clients";
    license = licenses.mit;
    maintainers = with maintainers; [ leona ];
  };
}
