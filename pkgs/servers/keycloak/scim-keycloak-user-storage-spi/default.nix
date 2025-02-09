{ lib
, fetchFromGitHub
, maven
}:

maven.buildMavenPackage {
  pname = "scim-keycloak-user-storage-spi";
  version = "unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "justin-stephenson";
    repo = "scim-keycloak-user-storage-spi";
    rev = "54a3fd77b05079c9ebd931e8b6a3725310a1f7b7";
    hash = "sha256-rQR8+LevFHTFLoyCPSu50jdSXu4YgBibjVB804rEsFs=";
  };

  mvnHash = "sha256-vNPSNoOmtD1UMfWvLm8CH7RRatyeu3fnX9zteZpkay0=";

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
