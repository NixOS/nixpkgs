# nix-instantiate --eval --strict . -A tests.vimConfigs
{ lib, pkgs }:

with lib;
lib.runTests {
  testMandatoryCheck = {
    expr = vimUtils.vimrcContent { customRC = ""; };
    expected = "toto";
  };
}
