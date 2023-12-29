{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-5FteKVlEx5NSj3lzRRj3qerkyK+UdJfTWtG6xEzI4t4=";
  };

  cargoHash = "sha256-gs8o+tWvC4cgIITpfvJqfTquyYaEbvNMeZEJKFzd83I=";

  meta = with lib; {
    description = "A tool to execute Rust code carefully, with extra checking along the way";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
