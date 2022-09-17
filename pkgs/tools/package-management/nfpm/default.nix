{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.18.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Plw8aN1fhZihPcV7dJrlE5Y1flwous7MvrUCJFmkXuc=";
  };

  vendorSha256 = "sha256-6RB27jFK6HI6CR8D9vAPshsRi3ldoQwTTH6S1gyDqxs=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = with maintainers; [ marsam techknowlogick ];
    license = with licenses; [ mit ];
  };
}
