{ stdenv, fetchgit, nodejs }:

let
  rev = "58b49ac2149fa9c120beb35c7d665bd9bbb313d2";
in
stdenv.mkDerivation {
  name = "cjdns-20130620-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "git://github.com/cjdelisle/cjdns.git";
    inherit rev;
    sha256 = "1bg46pswfv534z99dg515r4yz4icvzbc6lzva5my0z8w4frrh25a";
  };

  buildInputs = [ nodejs ];

  builder = ./builder.sh;

  meta = {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
