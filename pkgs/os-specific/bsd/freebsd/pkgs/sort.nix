{
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/sort";
  outputs = [
    "out"
    "debug"
  ];
  MK_TESTS = "no";
  meta.mainProgram = "sort";
}
