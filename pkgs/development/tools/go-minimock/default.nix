{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.0.10";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    sha256 = "sha256-zxEBX7+WYQE2BDZmF4N8imFOBPorrYzg55tLlWUO8Lo=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  vendorSha256 = "sha256-mIKknTrsJfFBKZrcxhnlDbvQq9q9FCOrk6ueJOoxOzk=";

  doCheck = true;

  subPackages = [ "cmd/minimock" "." ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "A golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
