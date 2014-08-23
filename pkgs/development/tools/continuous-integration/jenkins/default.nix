{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins";
  version = "1.550";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "1ziimbfs9kylga0xmxlfsfcc7qsirs5bnx00pa99m2l5sz2ki793";
  };
  meta = {
    description = "An extendable open source continuous integration server.";
    homepage = http://jenkins-ci.org;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.coconnor ];
  };

  buildCommand = "ln -s $src $out";
}
