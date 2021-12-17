{ lib, rustPlatform, fetchFromGitHub, pkg-config, zstd, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-nNMpCv7pokWK+rCV/jEvTpJNwTtZO5t2+etMRg3XJiQ=";
  };

  # enable pkg-config feature of zstd
  cargoPatches = [ ./zstd-pkg-config.patch ];

  cargoSha256 = "sha256-LC4vY/jyIPGY2UpB4LOKCCR/gv8EUfB4nH8h0O9c6iw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda ];
    broken = stdenv.isDarwin;
  };
}
