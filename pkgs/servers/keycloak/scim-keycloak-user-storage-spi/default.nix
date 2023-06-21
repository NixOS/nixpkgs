{ lib
, fetchFromGitHub
, maven
}:

maven.buildMavenPackage {
  pname = "scim-keycloak-user-storage-spi";
  version = "unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "justin-stephenson";
    repo = "scim-keycloak-user-storage-spi";
    rev = "e2a78d9dddbb21a42a9aaeb5c72b5ed1ef76d2a0";
    hash = "sha256-xFEXMZw575hONMG9ZNQ+5xKEVeKvGyzurqbAW48Mrg8=";
  };

  mvnHash = "sha256-kV3hjwEQ0jAhFm9EB9O0l87gCZGsRQ/9cazlSjHrY74=";

  nativeBuildInputs = [
    maven
  ];

  installPhase = ''
    install -D "target/scim-user-spi-0.0.1-SNAPSHOT.jar" "$out/scim-user-spi-0.0.1-SNAPSHOT.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/justin-stephenson/scim-keycloak-user-storage-spi";
    description = "A third party module that extends Keycloak, allow for user storage in an external scimv2 server";
    sourceProvenance = with sourceTypes; [
      fromSource
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
