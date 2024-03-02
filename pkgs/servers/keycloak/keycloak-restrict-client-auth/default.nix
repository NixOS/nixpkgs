{ maven, lib, fetchFromGitHub }:

maven.buildMavenPackage rec {
  pname = "keycloak-restrict-client-auth";
  version = "23.0.0";

  src = fetchFromGitHub {
    owner = "sventorben";
    repo = "keycloak-restrict-client-auth";
    rev = "v${version}";
    hash = "sha256-JA3DvLdBKyn2VE1pYSCcRV9Cl7ZAWsRG5MAp548Rl+g=";
  };

  mvnHash = "sha256-W1YvX1P/mshGYoTUO5XMlOcpu2KiujwLludaC3miak4=";

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
