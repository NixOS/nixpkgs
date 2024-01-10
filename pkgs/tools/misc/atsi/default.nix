{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "atsi";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "queer";
    repo = pname;
    rev = "0baf045c4de4862943e10d9a7bc28881f4706c71";
    sha256 = "sha256-k0kD98MHN6AuX+W8VeiX6ExyaLTTZlE4/+5nQQF/x/g=";
  };

  cargoSha256 = "sha256-Wsiyq57gwO6aZIzIj3YVJ5d/FFcqn1D5xGAIz+ZFh7w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Instant rootless Alpine shells";
    homepage = "https://github.com/queer/atsi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
