{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotrue";
  version = "2.35.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uFE2pcEpGhrl8LcZLvYEMlq8sgRmFkltf3H8huZzXpM=";
  };

  vendorHash = "sha256-uchgHxUczb4IIUkUdHWyeXWr2LXda6eWwjQxUBcPDoA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/netlify/gotrue/utilities.Version=${version}"
  ];

  # integration tests require network to connect to postgres database
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/gotrue";
    description = "A JWT based API for managing users and issuing JWT tokens";
    changelog = "https://github.com/supabase/gotrue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
