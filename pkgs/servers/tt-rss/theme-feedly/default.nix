{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tt-rss-theme-feedly";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "levito";
    repo = "tt-rss-feedly-theme";
    rev = "v${version}";
    sha256 = "sha256-a8IZZbTlVU8Cu1F/HwEnsUW3eRqaTnKuJ166WJIw9/A=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out

    cp -ra feedly *.css $out
  '';

  meta = with lib; {
    description = "Feedly theme for Tiny Tiny RSS";
    license = licenses.wtfpl;
    homepage = "https://github.com/levito/tt-rss-feedly-theme";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
