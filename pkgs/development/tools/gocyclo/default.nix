{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gocyclo";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fzipp";
    repo = "gocyclo";
    rev = "v${version}";
    sha256 = "1s9m5m5p76wcxi5n4diz891kd5db4ll21fsh9fnvvf9w7yrmgdw2";
  };

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with lib; {
    description = "Calculate cyclomatic complexities of functions in Go source code";
    homepage = "https://github.com/fzipp/gocyclo";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
