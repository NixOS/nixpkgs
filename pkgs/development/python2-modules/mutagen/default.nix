{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pycodestyle
, pyflakes
, pytest
, setuptools
, pkgs
}:

buildPythonPackage rec {
  pname = "mutagen";
  version = "1.43.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d873baeb7815311d3420aab0a1d83f050f628228cbc2d6045a14a16460411bc9";
  };

  propagatedBuildInputs = [ setuptools ];
  checkInputs = [
    pkgs.faad2 pkgs.flac pkgs.vorbis-tools pkgs.liboggz
    pkgs.glibcLocales pycodestyle pyflakes pytest hypothesis
  ];
  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "Python multimedia tagging library";
    homepage = "https://mutagen.readthedocs.io";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
