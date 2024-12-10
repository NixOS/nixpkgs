{
  lib,
  fetchFromGitHub,
  maven,
}:

maven.buildMavenPackage {
  pname = "scim-keycloak-user-storage-spi";
  version = "unstable-2024-02-14";

  src = fetchFromGitHub {
    owner = "justin-stephenson";
    repo = "scim-keycloak-user-storage-spi";
    rev = "6c59915836d9a559983326bbb87f895324bb75e4";
    hash = "sha256-BSso9lU542Aroxu0RIX6NARc10lGZ04A/WIWOVtdxHw=";
  };

  mvnHash = "sha256-xbGlVZl3YtbF372kCDh+UdK5pLe6C6WnGgbEXahlyLw=";

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
