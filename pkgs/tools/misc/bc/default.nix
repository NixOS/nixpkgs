{stdenv, fetchurl, flex, readline}:

stdenv.mkDerivation rec {
  name = "bc-1.06";
  src = fetchurl {
    url = "mirror://gnu/bc/${name}.tar.gz";
    sha256 = "0cqf5jkwx6awgd2xc2a0mkpxilzcfmhncdcfg7c9439wgkqxkxjf";
  };

  patches = [ ./readlinefix.patch ];

  configureFlags = [ "--with-readline" ];

  buildInputs = [flex readline];

  doCheck = true;

  meta = {
    description = "GNU software calculator";
    homepage = http://www.gnu.org/software/bc/;
    platforms = stdenv.lib.platforms.all;
  };
}
