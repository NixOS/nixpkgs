{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "errcheck-${version}";
  version = "1.1.0";

  goPackagePath = "github.com/kisielk/errcheck";
  excludedPackages = "\\(testdata\\)";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${version}";
    sha256 = "19vd4rxmqbk5lpiav3pf7df3yjlz0l0dwx9mn0gjq5f998iyhy6y";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "errcheck is a program for checking for unchecked errors in go programs.";
    homepage = https://github.com/kisielk/errcheck;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
