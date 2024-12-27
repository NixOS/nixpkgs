{ mkDerivation, defaultMakeFlags }:

mkDerivation {
  path = "share/misc";
  noCC = true;
  makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
}
