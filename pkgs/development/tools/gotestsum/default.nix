{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-eJxrdR3JYqF+GexcwnyHV4xO75stEDNFzxDtky7PVc8=";
  };

  vendorSha256 = "sha256-VQ3/VkxoYtY71xJQj6/XAoIEH4jr4Rq4hFqFnwxzkSU=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
