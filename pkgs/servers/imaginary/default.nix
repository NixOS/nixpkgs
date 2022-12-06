{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, vips
}:

buildGoModule rec {
  pname = "imaginary";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oEkFoZMaNNJPMisqpIneeLK/sA23gaTWJ4nqtDHkrwA=";
  };

  vendorSha256 = "sha256-BluY6Fz4yAKJ/A9aFuPPsgQN9N/5yd8g8rDfIZeYz5U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ vips ];

  ldflags = [
    "-s"
    "-w"
    "-h"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Fast, simple, scalable, Docker-ready HTTP microservice for high-level image processing";
    homepage = "https://github.com/h2non/imaginary";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
