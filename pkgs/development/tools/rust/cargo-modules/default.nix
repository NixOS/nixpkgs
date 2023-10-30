{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    hash = "sha256-71NRaIDWPbhDn6cfYhyZZzO2huQlj1vkKdBV6WJqI9s=";
  };

  cargoHash = "sha256-lgqe9pXg/PE9WrXVpSJWYE6FUMGBgUDpEyJ31RSEj5A=";

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
