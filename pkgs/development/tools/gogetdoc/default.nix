{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "gogetdoc-unstable-${version}";
  version = "2018-10-25";
  rev = "9098cf5fc236a5e25060730544af2ba6d65cd968";

  goPackagePath = "github.com/zmb3/gogetdoc";
  excludedPackages = "\\(testdata\\)";

  src = fetchFromGitHub {
    inherit rev;

    owner = "zmb3";
    repo = "gogetdoc";
    sha256 = "159dgkd2lz07kimbpzminli5p539l4ry0dr93r46iz3lk5q76znl";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Gets documentation for items in Go source code";
    homepage = https://github.com/zmb3/gogetdoc;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
