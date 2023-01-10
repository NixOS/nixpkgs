{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips }:

buildGoModule rec {
  pname = "imaginary";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oEkFoZMaNNJPMisqpIneeLK/sA23gaTWJ4nqtDHkrwA=";
  };

  vendorHash = "sha256-BluY6Fz4yAKJ/A9aFuPPsgQN9N/5yd8g8rDfIZeYz5U=";

  buildInputs = [ vips ];

  nativeBuildInputs = [ pkg-config ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://fly.io/docs/app-guides/run-a-global-image-service";
    changelog = "https://github.com/h2non/${pname}/releases/tag/v${version}";
    description = "Fast, simple, scalable, Docker-ready HTTP microservice for high-level image processing";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
