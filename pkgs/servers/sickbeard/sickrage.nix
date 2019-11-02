{ stdenv, fetchFromGitHub, python2, makeWrapper }:

python2.pkgs.buildPythonApplication rec {
  name = "sickrage-${version}";
  version = "v2018.07.21-1";

  src = fetchFromGitHub {
    owner = "SickRage";
    repo = "SickRage";
    rev = version; 
    sha256 = "0lzklpsxqrb73inbv8almnhbnb681pmi44gzc8i4sjwmdksiiif9";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python2 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R {gui,lib,locale,sickbeard,sickrage,SickBeard.py} $out/

    makeWrapper $out/SickBeard.py $out/bin/sickrage
  '';

  meta = with stdenv.lib; {
    description = "Automatic Video Library Manager for TV Shows";
    longDescription = "It watches for new episodes of your favorite shows, and when they are posted it does its magic.";
    license     = licenses.gpl3;
    homepage    = https://sickrage.github.io;
    maintainers = with maintainers; [ sterfield ];
  };
}
