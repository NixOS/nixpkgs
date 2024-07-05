{
  mkDerivation,
  libutil,
  libxo,
  ...
}:
mkDerivation {
  path = "sbin/mount";
  buildInputs = [
    libutil
    libxo
  ];
}
