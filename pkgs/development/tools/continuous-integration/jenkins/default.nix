{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.249.1";

  src = fetchurl {
    url = "http://mirrors.jenkins.io/war-stable/${version}/jenkins.war";
    sha256 = "1mjvxl48v0rdrs6hzwh4mx5xvx3lnqs6njx3d7nfdfp2nf2s9353";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/jenkins.war"
  '';

  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = https://jenkins-ci.org;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor fpletz earldouglas ];
  };
}
