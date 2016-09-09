{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "selfoss-${version}";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "SSilence";
    repo = "selfoss";
    rev = version;
    sha256 = "0ljpyd354yalpnqwj6xk9b9mq4h6p8jbqznapj7nvfybas8faq15";
  };

  buildPhases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir $out
    cp -ra * $out/
  '';

  meta = with stdenv.lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl3;
    homepage = http://http://selfoss.aditu.de/;
    platforms = platforms.all;
    maintainers = [ maintainers.regnat ];
  };
}

