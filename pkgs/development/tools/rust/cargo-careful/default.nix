{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-+rj9f4uCNDWwX+0Dsr7dwoeQunvsniG61+W9ehs0KDY=";
  };

  cargoHash = "sha256-dxb+euJ5PCdDjfne+iUTgsdOSt2HLiItHrVwHx4588c=";

  meta = with lib; {
    description = "A tool to execute Rust code carefully, with extra checking along the way";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
