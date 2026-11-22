{
  mkDerivation,
  libdevinfo,
}:
mkDerivation {
  path = "sbin/devmatch";
  outputs = [
    "out"
    "debug"
  ];
  buildInputs = [
    libdevinfo
  ];
}
