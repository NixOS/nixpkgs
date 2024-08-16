{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
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
    hash = "sha256-oEkFoZMaNNJPMisqpIneeLK/sA23gaTWJ4nqtDHkrwA=";
  };

  patches = [
    # add -return-size flag recommend by Nextcloud
    # https://github.com/h2non/imaginary/pull/382
    (fetchpatch {
      name = "return-width-and-height-of-generated-images.patch";
      url = "https://github.com/h2non/imaginary/commit/cfbf8d724cd326e835dfcb01e7224397c46037d3.patch";
      hash = "sha256-TwZ5WU5g9LXrenpfY52jYsc6KsEt2fjDq7cPz6ILlhA=";
    })
  ];

  vendorHash = "sha256-BluY6Fz4yAKJ/A9aFuPPsgQN9N/5yd8g8rDfIZeYz5U=";

  buildInputs = [ vips ];

  nativeBuildInputs = [ pkg-config ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://fly.io/docs/app-guides/run-a-global-image-service";
    changelog = "https://github.com/h2non/${pname}/releases/tag/v${version}";
    description = "Fast, simple, scalable, Docker-ready HTTP microservice for high-level image processing";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda urandom ];
    mainProgram = "imaginary";
  };
}
