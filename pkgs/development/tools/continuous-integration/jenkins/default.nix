{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.235.5";

  src = fetchurl {
    url = "http://mirrors.jenkins.io/war-stable/${version}/jenkins.war";
    sha256 = "02zpnqhdkhg8p8cddkqklgihjpwcbnybkcw5rspipz6kiyqzg1n7";
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
