{ stdenv, fetchgit, nodejs, which, python27 }:

let
  date = "20140303";
  rev = "f11ce1fd4795b0173ac0ef18c8a6f752aa824adb";
in
stdenv.mkDerivation {
  name = "cjdns-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "git://github.com/cjdelisle/cjdns.git";
    inherit rev;
    sha256 = "1bxhf9f1v0slf9mz3ll6jf45mkwvwxlf3yqxx9k23kjyr1nsc8s8";
  };

  buildInputs = [ which python27 nodejs];

  builder = ./builder.sh;

  meta = {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = stdenv.lib.platforms.linux;
  };
}
