{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jenkins-${version}";
  version = "1.638";

  src = fetchurl {
    url = "http://mirrors.jenkins-ci.org/war/${version}/jenkins.war";
    sha256 = "1kbx9n2hj8znw0ykvgvrlf2v472f1nkdwix6a2v4rjxkgmghxmh8";
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
