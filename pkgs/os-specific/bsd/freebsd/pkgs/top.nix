{
  mkDerivation,
  libjail,
  libncurses-tinfo,
  libutil,
  libsbuf,
  ...
}:
mkDerivation {
  path = "usr.bin/top";
  buildInputs = [
    libjail
    libncurses-tinfo
    libutil
    libsbuf
  ];
}
