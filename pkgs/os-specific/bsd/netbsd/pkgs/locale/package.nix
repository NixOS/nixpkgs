{ mkDerivation }:

mkDerivation {
  path = "usr.bin/locale";
  version = "9.2";
  sha256 = "0kk6v9k2bygq0wf9gbinliqzqpzs9bgxn0ndyl2wcv3hh2bmsr9p";
  patches = [ ./locale.patch ];
  env.NIX_CFLAGS_COMPILE = "-DYESSTR=__YESSTR -DNOSTR=__NOSTR";
}
