{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "1.649";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "10lvrdd6mfgkz0rdc41hg9fai44vzxy6qlayfvkjg29xgqm0n9ya";
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
