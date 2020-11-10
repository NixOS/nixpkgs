{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  version = "1.12";
  pname = "beanstalkd";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = "https://github.com/kr/beanstalkd/archive/v${version}.tar.gz";
    sha256 = "0gw8aygysnjzzfjgfzivy5vajla9adg2zcr4h8rrdf0xyykpwfpl";
  };

  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    homepage = "http://kr.github.io/beanstalkd/";
    description = "A simple, fast work queue";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
    platforms = platforms.all;
  };
}

