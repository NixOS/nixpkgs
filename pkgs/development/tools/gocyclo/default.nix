{ buildGoPackage, lib, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gocyclo";
  version = "0.3.1";
  rev = "v${version}";

  goPackagePath = "github.com/fzipp/gocyclo";

  src = fetchFromGitHub {
    inherit rev;

    owner = "fzipp";
    repo = "gocyclo";
    sha256 = "1rimdrhmy6nkzh7ydpx6139hh9ml6rdqg5gvkpy2l1x9mhanvan0";
  };

  meta = with lib; {
    description =
      "Calculate cyclomatic complexities of functions in Go source code";
    homepage = "https://github.com/fzipp/gocyclo";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
