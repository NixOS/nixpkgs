{ stdenv, fetchurl, fetchpatch, lua }:

stdenv.mkDerivation rec {
  version = "4.0.2";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "04s8cgvwjj1979s3hg8zkwc9pyn3jkjpz5zidp87kfcipifr385i";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-15047.patch";
      url = https://github.com/antirez/redis/commit/ffcf7d5ab1e98d84c28af9bea7be76c6737820ad.patch;
      sha256 = "0cgx3lm0n7jxhsly8v9hdvy6vlamj3ck2jsid4fwyapz6907h64l";
    })
  ];

  buildInputs = [ lua ];
  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://redis.io;
    description = "An open source, advanced key-value store";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}
