{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-oiwR6NgHHu9B1L6dSK6KZfgcSdwBPEzUZONwPHr0a4k=";
  };

  cargoHash = "sha256-sVIAY9eYlpyS/PU6kLInc4hMeD3qcewoMbTH+wTIBuI=";

  meta = with lib; {
    description = "A tool to execute Rust code carefully, with extra checking along the way";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
