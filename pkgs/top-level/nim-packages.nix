{ lib, pkgs, stdenv, newScope, nim, fetchFromGitHub }:

lib.makeScope newScope (self:
  let callPackage = self.callPackage;
  in {
    inherit nim;
    nim_builder = callPackage ../development/nim-packages/nim_builder { };
    buildNimPackage =
      callPackage ../development/nim-packages/build-nim-package { };
    fetchNimble = callPackage ../development/nim-packages/fetch-nimble { };

  })
