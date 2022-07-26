{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "frewsxcv";
    repo = pname;
    rev = version;
    sha256 = "1pdr34ygc0qmh0dyrw1qcrh1vgg9jv9lm6ypl3fgjzz7npdj1dw4";
  };

  cargoSha256 = "sha256-BsRJo55gYT8OkDUBepWq48sW7QPt5OZkm8RR9f7HqZY=";

  meta = with lib; {
    description = "A Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
