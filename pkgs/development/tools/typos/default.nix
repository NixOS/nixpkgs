{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.14.11";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4E28pBZ+uWDaEXty4ZgbbEcO3lpluOXopgPr/6Xl/z4=";
  };

  cargoHash = "sha256-BegIKd+1K1Dh1ULIiRcpkq/5JdlofRURmRTtyD0tWMg=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda mgttlinger ];
  };
}
