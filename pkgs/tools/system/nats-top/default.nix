{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IZQDwopFAXPT0V+TTiJk6+j/KhLTA3g4kN1j1PVlNt0=";
  };

  vendorSha256 = "sha256-cBCR/OXUOa+Lh8UvL/VraDAW0hGGwV7teyvdswZQ5Lo=";

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
