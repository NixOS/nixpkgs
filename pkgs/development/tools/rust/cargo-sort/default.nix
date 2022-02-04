{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jESz3SujznGLJeR23LvxORNC0Tj4VcEzdzhIRwyvjd0=";
  };

  cargoSha256 = "sha256-1iOZ1EEP4bObTweTN4Wjtb9Y9ysJQ/9xnNpprxKIaho=";

  meta = with lib; {
    description = "A tool to check that your Cargo.toml dependencies are sorted alphabetically";
    homepage = "https://github.com/devinr528/cargo-sort";
    changelog = "https://github.com/devinr528/cargo-sort/blob/v${version}/changelog.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
