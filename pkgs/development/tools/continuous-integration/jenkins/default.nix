{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "2.49";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "0c7qnrx87wrgxgh4im1i6sqlxq3hsrs119krh5vwjzx5wp6daa93";
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
