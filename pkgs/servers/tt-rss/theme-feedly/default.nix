{ stdenv, fetchFromGitHub }: stdenv.mkDerivation rec {
  pname = "tt-rss-theme-feedly";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "levito";
    repo = "tt-rss-feedly-theme";
    rev = "v${version}";
    sha256 = "0rl5g664grx3m7yxa14rgnbvnlc3xnn44kzjji5layxww6jd8h2s";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out

    cp -ra feedly *.css $out
  '';

  meta = with stdenv.lib; {
    description = "Feedly theme for Tiny Tiny RSS";
    license = licenses.wtfpl;
    homepage = "https://github.com/levito/tt-rss-feedly-theme";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
