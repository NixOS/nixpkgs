{ mkDerivation, lib, stdenv, libpam, ... }:
mkDerivation {
  path = "secure/lib/libssh";
  extraPaths = ["crypto/openssh" "secure/ssh.mk"];
  buildInputs = [libpam];

  clangFixup = true;

  MK_TESTS = "no";
}
