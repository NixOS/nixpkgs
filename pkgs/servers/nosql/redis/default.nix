{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "redis";
  version = "2.4.7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://redis.googlecode.com/files/redis-2.4.7.tar.gz";
    sha256 = "f91956377b7ff23cc23e0c8758e0b873032f36545c61d88436ebb741bf4dd5e1";
  };

  makeFlags = "PREFIX=$(out)";

  # commented out until the patch is found
  # patches = if stdenv.isDarwin then [ ./darwin.patch ] else [];
  meta = {
    homepage = http://redis.io;
    description = "An open source, advanced key-value store";
    license = "BSD";

    platforms = stdenv.lib.platforms.unix;
  };
}
