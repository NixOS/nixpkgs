{ stdenv, fetchFromGitHub }: stdenv.mkDerivation rec {
  name = "tt-rss-theme-feedly-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "levito";
    repo = "tt-rss-feedly-theme";
    rev = "v${version}";
    sha256 = "1n5vci84l0wxsd2k90m2x3j8d7y9kz5fqc6fk6y7r568p1cakg9b";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out

    cp -ra feedly feedly.css $out
  '';

  meta = with stdenv.lib; {
    description = "Feedly theme for Tiny Tiny RSS";
    license = licenses.wtfpl;
    homepage = https://github.com/levito/tt-rss-feedly-theme;
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
