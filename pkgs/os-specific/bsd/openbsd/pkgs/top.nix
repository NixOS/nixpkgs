{ mkDerivation, libcurses }:
mkDerivation {
  path = "usr.bin/top";

  buildInputs = [ libcurses ];
}
