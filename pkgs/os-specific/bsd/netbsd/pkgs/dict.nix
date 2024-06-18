{ mkDerivation, defaultMakeFlags }:

mkDerivation {
  path = "share/dict";
  noCC = true;
  version = "9.2";
  sha256 = "0svfc0byk59ri37pyjslv4c4rc7zw396r73mr593i78d39q5g3ad";
  makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
}
