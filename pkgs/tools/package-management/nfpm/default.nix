{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jmxafvxzqg65zg5cnjd2nsz1mmw06mc7qz3lbs5h2gkxiah8264";
  };

  vendorSha256 = "0yvzwbm0xb1h45x96h658avbjz9w79aaa6z042xpvjqc4wsr8155";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
