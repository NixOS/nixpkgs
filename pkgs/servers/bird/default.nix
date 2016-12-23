{ stdenv, fetchurl, flex, bison, readline
, enableIPv6 ? false }:

stdenv.mkDerivation rec {
  name = "bird-1.6.3";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
    sha256 = "0z3yrxqb0p7f8b7r2gk4mvrwfzk45zx7yr9aifbvba1vgksiri9r";
  };

  buildInputs = [ flex bison readline ];

  patches = [
    ./dont-create-sysconfdir.patch
  ];

  configureFlags = [
    "--localstatedir /var"
  ] ++ stdenv.lib.optional enableIPv6 "--enable-ipv6";

  meta = {
    description = "BIRD Internet Routing Daemon";
    homepage = http://bird.network.cz;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ viric fpletz ];
    platforms  = stdenv.lib.platforms.linux;
  };
}
