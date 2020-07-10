{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z6z4ad5id6bcxzd8p76akxwvf5jzr54w81798ri9lysf4hdi6sh";
  };

  vendorSha256 = "0v14j4vsp7f29xajym2dd2zlfv0sqhb04qfs76bcnn0ys6j1xkny";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}