{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "2.71";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "0b3mxbcv7afj8ksr2y33rvprj7003679j545igf5dsal82i7swhl";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/jenkins.war"
  '';

  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = http://jenkins-ci.org;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor fpletz ];
  };
}
