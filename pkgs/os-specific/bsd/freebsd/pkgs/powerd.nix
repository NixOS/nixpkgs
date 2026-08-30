{
  mkDerivation,
}:
mkDerivation {
  path = "usr.sbin/powerd";
  outputs = [
    "out"
    "debug"
  ];
  meta.mainProgram = "powerd";
}
