{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4BQdZsnK3Wv7A3I/yCrnPALac2/sSopRPVh/57vvmGw=";
  };

  cargoSha256 = "sha256-JM9HdPEZA9c8NGeu9qRwj0jGUsMltsOUG6itNbXZ3Ts=";

  meta = with lib; {
    description =
      "A tool to check that your Cargo.toml dependencies are sorted alphabetically";
    homepage = "https://github.com/devinr528/cargo-sort";
    changelog =
      "https://github.com/devinr528/cargo-sort/blob/v${version}/changelog.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
