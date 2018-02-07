{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "selfoss-unstable-${version}";
  version = "2016-07-31";

  src = fetchFromGitHub {
    owner = "SSilence";
    repo = "selfoss";
    rev = "ceb431ad9208e2c5e31dafe593c75e5eb8b65cf7";
    sha256 = "00vrpw7sb95x6lwpaxrlzxyj98k98xblqcrjr236ykv0ha97xv30";
  };

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

