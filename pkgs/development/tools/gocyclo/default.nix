{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "gocyclo-unstable-${version}";
  version = "2015-02-08";
  rev = "aa8f8b160214d8dfccfe3e17e578dd0fcc6fede7";

  goPackagePath = "github.com/alecthomas/gocyclo";

  src = fetchFromGitHub {
    inherit rev;

    owner = "alecthomas";
    repo = "gocyclo";
    sha256 = "094rj97q38j53lmn2scshrg8kws8c542yq5apih1ahm9wdkv8pxr";
  };

  meta = with lib; {
    description = "Calculate cyclomatic complexities of functions in Go source code.";
    homepage = https://github.com/alecthomas/gocyclo;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
