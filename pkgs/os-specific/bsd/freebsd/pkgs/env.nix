{
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/env";
  outputs = [
    "out"
    "debug"
  ];
  MK_TESTS = "no";
  meta.mainProgram = "env";
}
