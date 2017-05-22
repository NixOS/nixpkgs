{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "2.61";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "1h5im8158h403n5sj1xyhmq40pdq2pmbh7gqv3sv74mc3rjaffj5";
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
