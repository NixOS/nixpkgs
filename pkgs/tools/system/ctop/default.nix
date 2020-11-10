{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zslxd00pypn6ri7r420mqxjqy3i6qv944f7899saapsb2m08w7j";
  };

  vendorSha256 = "0a5rwnf251jbp7jz2ln8z9hqp0112c6kx0y09nncvlcki35qq9sh";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.build=v${version}" ];

  meta = with lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux marsam ];
  };
}
