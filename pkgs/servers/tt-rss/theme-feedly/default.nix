{ stdenv, fetchFromGitHub }: stdenv.mkDerivation rec {
  pname = "tt-rss-theme-feedly";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "levito";
    repo = "tt-rss-feedly-theme";
    rev = "v${version}";
    sha256 = "1fqzxz4ddqj10zdf4rbm7w1zbxb54gkqh34qasqgs3bp4y33pdl3";
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
