{ lib
<<<<<<< HEAD
, fetchFromGitHub
, maven
}:

maven.buildMavenPackage {
  pname = "scim-keycloak-user-storage-spi";
  version = "unstable-2023-07-10";
=======
, stdenv
, fetchFromGitHub
, maven
, javaPackages
}:

javaPackages.mavenfod rec {
  pname = "scim-keycloak-user-storage-spi";
  version = "unstable-2023-04-12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "justin-stephenson";
    repo = "scim-keycloak-user-storage-spi";
<<<<<<< HEAD
    rev = "54a3fd77b05079c9ebd931e8b6a3725310a1f7b7";
    hash = "sha256-rQR8+LevFHTFLoyCPSu50jdSXu4YgBibjVB804rEsFs=";
  };

  mvnHash = "sha256-vNPSNoOmtD1UMfWvLm8CH7RRatyeu3fnX9zteZpkay0=";
=======
    rev = "e2a78d9dddbb21a42a9aaeb5c72b5ed1ef76d2a0";
    hash = "sha256-xFEXMZw575hONMG9ZNQ+5xKEVeKvGyzurqbAW48Mrg8=";
  };

  mvnHash = "sha256-CK42d+Ta1/XNQWCLaje6sI+C90YvzUcteuasVkUPfCk=";

  nativeBuildInputs = [
    maven
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
