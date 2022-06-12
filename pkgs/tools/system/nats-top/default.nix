{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yPaaHSCLocgX0KQtHSBAi9GQqPlggdLAADr9ow7WlnU=";
  };

  vendorSha256 = "sha256-cBCR/OXUOa+Lh8UvL/VraDAW0hGGwV7teyvdswZQ5Lo=";

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
