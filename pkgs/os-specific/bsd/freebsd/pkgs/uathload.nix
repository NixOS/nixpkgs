{
  mkDerivation,
  bintrans,
}:
mkDerivation {
  path = "usr.sbin/uathload";
  extraPaths = [
    "sys/contrib/dev/uath"
  ];
  outputs = [
    "out"
    "debug"
  ];
  extraNativeBuildInputs = [
    bintrans
  ];
  postPatch = ''
    substituteInPlace usr.sbin/uathload/uathload.c --replace-fail _PATH_FIRMWARE '"${builtins.placeholder "out"}/share/firmware"'
  '';
}
