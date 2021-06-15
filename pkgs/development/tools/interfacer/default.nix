{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "interfacer-unstable";
  version = "2018-08-31";
  rev = "c20040233aedb03da82d460eca6130fcd91c629a";

  goPackagePath = "mvdan.cc/interfacer";
  excludedPackages = "check/testdata";

  src = fetchFromGitHub {
    inherit rev;

    owner = "mvdan";
    repo = "interfacer";
    sha256 = "0cx4m74mvn200360pmsqxx4z0apk9fcknwwqh8r94zd3jfv4akq2";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A linter that suggests interface types";
    homepage = "https://github.com/mvdan/interfacer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
