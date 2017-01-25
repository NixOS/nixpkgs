{ stdenv, lib, bundlerEnv, gpgme, ruby, ncurses, writeText, zlib, xapian
, pkgconfig, which }:

bundlerEnv {
  inherit ruby;

  pname = "lolcat";
  gemdir = ./.;

  meta = with lib; {
    description = "A rainbow version of cat";
    homepage    = https://github.com/busyloop/lolcat;
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ pSub ];
  };
}
