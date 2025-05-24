{
  lib,
  mkDerivation,
  defaultMakeFlags,
}:
mkDerivation {
  path = "share/misc";
  noCC = true;
  makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];

  meta.platforms = lib.platforms.unix;
}
