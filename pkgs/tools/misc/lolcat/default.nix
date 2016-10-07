{ stdenv, lib, bundlerEnv, gpgme, ruby, ncurses, writeText, zlib, xapian
, pkgconfig, which }:

bundlerEnv {
  name = "lolcat-42.1.43";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A rainbow version of cat";
    homepage    = https://github.com/busyloop/lolcat;
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ pSub ];
  };
}
