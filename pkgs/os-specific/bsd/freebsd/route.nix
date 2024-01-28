{ mkDerivation, lib, stdenv, compatIfNeeded, libjail, ...}:
mkDerivation {
  path = "sbin/route";

  buildInputs = compatIfNeeded ++ [ libjail ];

  MK_TESTS = "no";

  clangFixup = true;
}
