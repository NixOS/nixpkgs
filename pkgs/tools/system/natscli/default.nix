{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ktO+WrsacnQOgPZeyNTyUSATVwVud399YmcqgJ4PLTw=";
  };

  vendorHash = "sha256-5v3pPzt/U6kAHF9K7bb+Wu39gLh0O4TDIRgEToPNT6c=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
