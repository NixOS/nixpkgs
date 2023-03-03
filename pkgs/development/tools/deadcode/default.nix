{ buildGoPackage
, lib
, fetchFromGitHub
}:

# TODO(yl): should we package https://github.com/remyoudompheng/go-misc instead of
# the standalone extract of deadcode from it?
buildGoPackage rec {
  pname = "deadcode-unstable";
  version = "2016-07-24";
  rev = "210d2dc333e90c7e3eedf4f2242507a8e83ed4ab";

  goPackagePath = "github.com/tsenart/deadcode";
  excludedPackages = "cmd/fillswitch/test-fixtures";

  src = fetchFromGitHub {
    inherit rev;

    owner = "tsenart";
    repo = "deadcode";
    sha256 = "05kif593f4wygnrq2fdjhn7kkcpdmgjnykcila85d0gqlb1f36g0";
  };

  meta = with lib; {
    description = "Very simple utility which detects unused declarations in a Go package";
    homepage = "https://github.com/remyoudompheng/go-misc/tree/master/deadcode";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
