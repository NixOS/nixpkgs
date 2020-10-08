{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.249.2";

  src = fetchurl {
    url = "http://mirrors.jenkins.io/war-stable/${version}/jenkins.war";
    sha256 = "08m5z4ik96gnhw92hjzch7rpvrs0dipi9fps4rihwwzg5k26rc0v";
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
