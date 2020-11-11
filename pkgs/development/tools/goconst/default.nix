{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "goconst";
  version = "1.3.2";

  goPackagePath = "github.com/jgautheron/goconst";

  excludedPackages = [ "tests" ];

  src = fetchFromGitHub {
    owner = "jgautheron";
    repo = "goconst";
    rev = version;
    sha256 = "0bfiblp1498ic5jbdsm6mnc8s9drhasbqsw0asi6kmcz2kmslp9s";
  };

  meta = with lib; {
    description = "Find in Go repeated strings that could be replaced by a constant";
    homepage = "https://github.com/jgautheron/goconst";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
