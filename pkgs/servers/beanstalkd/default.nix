{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  version = "1.10";
  name = "beanstalkd-${version}";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = "https://github.com/kr/beanstalkd/archive/v${version}.tar.gz";
    sha256 = "0n9dlmiddcfl7i0f1lwfhqiwyvf26493fxfcmn8jm30nbqciwfwj";
  };

  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    homepage = http://kr.github.io/beanstalkd/;
    description = "A simple, fast work queue";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
    platforms = platforms.all;
  };
}

