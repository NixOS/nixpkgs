{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  version = "1.9";
  name = "beanstalkd-${version}";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = "https://github.com/kr/beanstalkd/archive/v${version}.tar.gz";
    sha256 = "158e6d6090c0afac7ee17b9f22713506b3e870dc04a738517282e2e262afb9eb";
  };

  meta = with stdenv.lib; {
    homepage = http://kr.github.io/beanstalkd/;
    description = "Beanstalk is a simple, fast work queue.";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
    platforms = platforms.all;
  };
}

