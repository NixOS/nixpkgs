{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "go-tools-${version}";
  version = "2019.1.1";

  goPackagePath = "honnef.co/go/tools";
  excludedPackages = ''\(simple\|ssa\|ssa/ssautil\|lint\|staticcheck\|stylecheck\|unused\)/testdata'';

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = "${version}";
    sha256 = "1zwh64x3i32p6f6808q609n63xda3bq888n43wl4alpx1b08spha";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis.";
    homepage = https://staticcheck.io;
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
