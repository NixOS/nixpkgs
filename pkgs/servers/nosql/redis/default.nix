{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "redis";
  version = "2.6.9";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://redis.googlecode.com/files/redis-2.6.9.tar.gz";
    sha256 = "4d967eff2038aebea33875d17e85ed67179df6505df68529a622f7836d1c7489";
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
