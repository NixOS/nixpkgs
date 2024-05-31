{ lib, mkDerivation }:

mkDerivation {
  path = "usr.bin/cksum";
  version = "9.2";
  sha256 = "0msfhgyvh5c2jmc6qjnf12c378dhw32ffsl864qz4rdb2b98rfcq";
  meta.platforms = lib.platforms.netbsd;
}
