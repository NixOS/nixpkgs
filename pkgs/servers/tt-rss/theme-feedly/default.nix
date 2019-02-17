{ stdenv, fetchFromGitHub }: stdenv.mkDerivation rec {
  name = "tt-rss-theme-feedly-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "levito";
    repo = "tt-rss-feedly-theme";
    rev = "v${version}";
    sha256 = "024hngwzfdgw5jqppc8vh75jidfqghaccy969hvbhxhgk6j6l8m4";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out

    cp -ra feedly feedly.css $out
  '';

  meta = with stdenv.lib; {
    description = "Feedly theme for Tiny Tiny RSS";
    license = licenses.wtfpl;
    homepage = "https://github.com/levito/tt-rss-feedly-theme";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
