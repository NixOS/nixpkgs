{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreFoundation, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "sha256-bLljwxNrCmg1ZWfSninIxJIFIn2oHY8dmbHYPdwtD+M=";
  };

  cargoSha256 = "sha256-heyVeQwEIOA9qtyXnHY8lPo06YgIUJaWCtaht9dWLoo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
