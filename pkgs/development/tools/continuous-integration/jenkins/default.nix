{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "2.77";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "1hmj5f14qpq58018q2jmdd4j36v2idsbb9caiakxfy08gppzhz00";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "11vy3wsc9b45146ninynq18ip2d99wfbl2sas9h1i418jxw88lf5";

  buildCommand = ''
    mkdir -p "$out/webapps/"
    ln -s "${src}" "$out/webapps/jenkins.war"
  '';

  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = http://jenkins-ci.org;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor fpletz ];
  };
}
