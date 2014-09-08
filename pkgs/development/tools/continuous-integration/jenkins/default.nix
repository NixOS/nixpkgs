{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "1.579";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "1l2a8h3js42gkqn8kiysbgrxksqmhmmfp9l4kbrmw609q2wn5119";
  };
  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = http://jenkins-ci.org;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.coconnor ];
  };

  buildCommand = "ln -s $src $out";
}
