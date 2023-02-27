{ lib
, stdenv
, fetchFromGitHub
, maven
, javaPackages
}:

javaPackages.mavenfod rec {
  pname = "scim-keycloak-user-storage-spi";
  version = "unstable-2023-01-03";

  src = fetchFromGitHub {
    owner = "justin-stephenson";
    repo = "scim-keycloak-user-storage-spi";
    rev = "1be97049edf096ca0d9a78d988623d5d3f310fb1";
    hash = "sha256-aGHInyy+VgyfjrXeZ6T6jfI00xaCwrRTehnew+mWYnQ=";
  };

  mvnHash = "sha256-CK42d+Ta1/XNQWCLaje6sI+C90YvzUcteuasVkUPfCk=";

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
