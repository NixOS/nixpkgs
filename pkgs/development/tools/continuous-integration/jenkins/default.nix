{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.235.3";

  src = fetchurl {
    url = "http://mirrors.jenkins.io/war-stable/${version}/jenkins.war";
    sha256 = "109rycgy8bg3na173vz5f3bq7w33a6kap8158kx6zhignni451p8";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/jenkins.war"
  '';

  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = "https://jenkins-ci.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor fpletz earldouglas ];
  };
}
