{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "goconst";
  version = "1.4.0";

  goPackagePath = "github.com/jgautheron/goconst";

  excludedPackages = [ "tests" ];

  src = fetchFromGitHub {
    owner = "jgautheron";
    repo = "goconst";
    rev = version;
    sha256 = "0jp9vg5l4wcvnf653h3d8ay2n7y717l9z34rls1vrsaf0qdf1r6v";
  };

  meta = with lib; {
    description = "Find in Go repeated strings that could be replaced by a constant";
    homepage = "https://github.com/jgautheron/goconst";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
