{ dhallPackages, lib }:

# This file tests that dhallPackages.buildDhallUrl is able to successfully
# build a Nix Dhall package for a given remote Dhall import.
#
# TODO: It would be nice to extend this test to make sure that the resulting
# Nix Dhall package is has the expected contents.

dhallPackages.buildDhallUrl {
  url = "https://raw.githubusercontent.com/cdepillabout/example-dhall-nix/e6a675c72ecd4dd23d254a02aea8181fe875747f/mydhallfile.dhall";
  hash = "sha256-434x+QjHRzuprBdw0h6wmwB1Zj6yZqQb533me8XdO4c=";
  dhallHash = "sha256:e37e31f908c7473ba9ac1770d21eb09b0075663eb266a41be77de67bc5dd3b87";
  source = true;
}
