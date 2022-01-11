{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-diet";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R40cggAdNbd8/+fG87PYHIbmgIsrhEwQ9ocB4p22bL4=";
  };

  cargoSha256 = "sha256-lgCP5P7X9B4sTND+p8repZB63c64o1QuozJoz6KQXiE=";

  meta = with lib; {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
