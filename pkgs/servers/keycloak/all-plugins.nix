{ callPackage }:

{
  scim-for-keycloak = callPackage ./scim-for-keycloak {};
  keycloak-discord = callPackage ./keycloak-discord {};
}
