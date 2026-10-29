{
  lib,
  mkDerivation,
  flex,
  byacc,
  libjail,
}:
mkDerivation {
  path = "usr.sbin/jail";
  extraNativeBuildInputs = [
    flex
    byacc
  ];
  buildInputs = [
    libjail
  ];
  MK_TESTS = "no";
  meta.mainProgram = "jail";
}
