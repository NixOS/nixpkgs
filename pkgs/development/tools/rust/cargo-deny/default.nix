{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, curl
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-QgaiyGBz23x3HkUv8fMNgEQyBvtPoZPbRCCVOQ5cJd0=";
  };

  cargoSha256 = "sha256-Q334bsDFs0AT8ZZDcbT8PyYUK9nF3GIeVjlGkcbObAo=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  buildNoDefaultFeatures = true;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog =
      "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
