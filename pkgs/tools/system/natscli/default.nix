{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Sro0EwHP1pszuOYP6abZO5XjJvbXrDDeSAbzPA2p00M=";
  };

  vendorSha256 = "sha256-HSKBUw9ZO150hLXyGX66U9XpLX2yowxYVdcdDVdqrAc=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
