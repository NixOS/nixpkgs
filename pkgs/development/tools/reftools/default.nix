{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "reftools-unstable";
  version = "2018-09-14";
  rev = "654d0ba4f96d62286ca33cd46f7674b84f76d399";

  goPackagePath = "github.com/davidrjenni/reftools";
  excludedPackages = "\\(cmd/fillswitch/test-fixtures\\)";

  src = fetchFromGitHub {
    inherit rev;

    owner = "davidrjenni";
    repo = "reftools";
    sha256 = "12y2h1h15xadc8pa3xsj11hpdxz5dss6k7xaa4h1ifkvnasjp5w2";
  };

  meta = with lib; {
    description = "reftools - refactoring tools for Go";
    homepage = https://github.com/davidrjenni/reftools;
    license = licenses.bsd2;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
