{ lib, rustPlatform, fetchCrate, stdenv, CoreFoundation, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Fm3D1VnudZhXpH7ymQNpViwwODvXYeO/e2xT3XXfclk=";
  };

  cargoSha256 = "sha256-PiYonf+aD+Q3mWtP+7NDu9wu3vKrMRAlYh94fXLMWD8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    CoreServices
  ];

  # the crate version doesn't include all the files required to run tests
  doCheck = false;

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
