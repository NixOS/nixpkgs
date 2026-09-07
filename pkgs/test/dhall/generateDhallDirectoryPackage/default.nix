{ dhallPackages, fetchFromGitHub }:

# This file tests that dhallPackages.generateDhallDirectoryPackage works.
#
# TODO: It would be nice to extend this test to make sure that the resulting
# Nix file has the expected contents, but it might be tough to do that easily
# without IFD.

dhallPackages.generateDhallDirectoryPackage {
  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo = "example-dhall-nix";
    rev = "e6a675c72ecd4dd23d254a02aea8181fe875747f";
    sha256 = "sha256-c/EZq76s/+hmLkaeJWKqgh2KrHuJRYI6kWry0E0YQ6s=";
  };
  file = "mydhallfile.dhall";
}
