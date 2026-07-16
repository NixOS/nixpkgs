{
  mkDerivation,
  flex,
}:
mkDerivation {
  path = "usr.sbin/autofs";
  extraPaths = [
    "sys/fs/autofs"
  ];
  outputs = [
    "out"
    "debug"
  ];
  extraNativeBuildInputs = [
    flex
  ];
}
