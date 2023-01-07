{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "sha256-xjAjm23hzuyvxU0S7m9AsfvXui/jb0oFrAqcY8m9Cq0=";
  };

  cargoSha256 = "sha256-XU4kNP0xODuY5I16zLZeQqpxS37HJI67YF3enB/5N+s=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    changelog = "https://github.com/regexident/cargo-modules/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
