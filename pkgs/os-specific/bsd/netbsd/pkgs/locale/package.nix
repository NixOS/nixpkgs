{ mkDerivation }:

mkDerivation {
  path = "usr.bin/locale";
  patches = [ ./locale.patch ];
  env.NIX_CFLAGS_COMPILE = "-DYESSTR=__YESSTR -DNOSTR=__NOSTR";
}
