{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "2.88";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "062hnbyj73311sxhkwla6sl33zb43v8p7hjssgbh0bfvgmnlayim";
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
    maintainers = with maintainers; [ coconnor fpletz earldouglas ];
  };
}
