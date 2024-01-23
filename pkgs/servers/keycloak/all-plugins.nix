{ callPackage }:

{
  scim-for-keycloak = callPackage ./scim-for-keycloak {};
  scim-keycloak-user-storage-spi = callPackage ./scim-keycloak-user-storage-spi {};
  keycloak-discord = callPackage ./keycloak-discord {};
  keycloak-metrics-spi = callPackage ./keycloak-metrics-spi {};
  keycloak-restrict-client-auth = callPackage ./keycloak-restrict-client-auth {};
}
