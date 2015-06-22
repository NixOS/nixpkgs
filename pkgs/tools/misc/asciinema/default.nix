{ stdenv, fetchFromGitHub, goPackages }:

goPackages.buildGoPackage rec {
  name = "asciinema-${version}";
  version = "1.1.1";

  goPackagePath = "github.com/asciinema/asciinema";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "d6f7cabcd085e237872f13d0ab5580964cb64fb2";
    sha256 = "0ip7wcqzf5wax99c1fjmnwd38q88z1xiyv9cfbjyk47npdqb8173";
  };

  meta = {
    homepage = https://asciinema.org/;
    license = stdenv.lib.licenses.gpl3;
    description = "Terminal session recorder";
    maintainers = with stdenv.lib.maintainers; [ lassulus ];
  };
}
