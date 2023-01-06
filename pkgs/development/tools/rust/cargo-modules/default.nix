{ lib, rustPlatform, fetchFromGitHub, fetchpatch, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "sha256-QRBhlSHqOTJCdzZhqpcfLeCDuCfJsjyxa2+6yzzN52g=";
  };

  cargoSha256 = "sha256-+asFAkUOHP9u/nOoHsr81KeqQkLqaRXhJH32oTG5vYo=";

  cargoPatches = [
    # https://github.com/regexident/cargo-modules/pull/161;
    (fetchpatch {
      name = "update-outdated-lock-file.patsh";
      url = "https://github.com/regexident/cargo-modules/commit/ea9029b79acdadddbaf4067076690153c38cd09c.patch";
      sha256 = "sha256-DOLvo/PP+4/6i1IYbl9oGC6BAnXNI88hK5he9549EJk=";
    })
  ];

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
