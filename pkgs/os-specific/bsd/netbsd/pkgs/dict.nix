{ mkDerivation, defaultMakeFlags }:

mkDerivation {
  path = "share/dict";
  noCC = true;
  makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
}
