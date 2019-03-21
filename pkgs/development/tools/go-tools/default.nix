{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "go-tools-${version}";
  version = "2017.2.2";

  goPackagePath = "honnef.co/go/tools";
  excludedPackages = ''\(simple\|ssa\|ssa/ssautil\|lint\|staticcheck\|unused\)/testdata'';

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = "${version}";
    sha256 = "1khl6szjj0skkfqp234p9rf3icik7fw2pk2x0wbj3wa9q3f84hb7";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis.";
    homepage = https://staticcheck.io;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
