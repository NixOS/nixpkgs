{ stdenv, fetchurl, openssl, zlib, e2fsprogs }:

stdenv.mkDerivation {
  name = "tarsnap-1.0.35";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz";
    sha256 = "16lc14rwrq84fz95j1g10vv0qki0qw73lzighidj5g23pib6g7vc";
  };

  buildInputs = [ openssl zlib e2fsprogs ];

  meta = {
    description = "Online backups for the truly paranoid";
    homepage = "http://www.tarsnap.com/";
    maintainers = with stdenv.lib.maintainers; [roconnor];
  };
}
