{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tt-rss-theme-feedly";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "levito";
    repo = "tt-rss-feedly-theme";
    rev = "v${version}";
    sha256 = "sha256-3mD1aY7gjdvucRzY7sLmZ1RsHtraAg1RGE/3uDp6/o4=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out

    cp -ra feedly *.css $out
  '';

  meta = with lib; {
    description = "Feedly theme for Tiny Tiny RSS";
    license = licenses.mit;
    homepage = "https://github.com/levito/tt-rss-feedly-theme";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
