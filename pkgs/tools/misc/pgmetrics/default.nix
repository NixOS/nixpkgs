{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-rqaK94Rw0K1+r7+7jHI2bzBupCGTkokeC4heJ3Yu6pQ=";
  };

  vendorSha256 = "sha256-5f2hkOgAE4TrHNz7xx1RU9fozxjFZAl4HilhAqsbo5s=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
