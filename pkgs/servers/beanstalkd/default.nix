{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  version = "1.11";
  pname = "beanstalkd";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = "https://github.com/kr/beanstalkd/archive/v${version}.tar.gz";
    sha256 = "0i65d0pln1p6wxghzwziz2k8vafvdgjq6yc962ayzs80kpj18d2y";
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

