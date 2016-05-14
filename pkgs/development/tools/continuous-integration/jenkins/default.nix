{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "2.3";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "0x59dbvh6y25ki5jy51djbfbhf8g2j3yd9f3n66f7bkdfw8p78g1";
  };
  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = http://jenkins-ci.org;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.coconnor ];
  };

  buildCommand = "cp $src $out";
}
