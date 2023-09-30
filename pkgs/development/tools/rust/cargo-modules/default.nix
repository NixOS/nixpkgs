{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    hash = "sha256-GbBPIJh2TnIpzpuSLZlrxEVN5hWFakeERKNeTcYbjSY=";
  };

  cargoHash = "sha256-g8Edt2rmOSfoJ3UsZIUyTOIxXgf6iQD+TueK89d18CQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    changelog = "https://github.com/regexident/cargo-modules/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago matthiasbeyer ];
  };
}
