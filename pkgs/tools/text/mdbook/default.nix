{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.26";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+K2mbVbOMQDumcPgiPtqDts/RGi+E0lF7Cftt86X/5A=";
  };

  cargoHash = "sha256-C9ziW3LUBGR/K+nR3mDr62KoE9p3mn+50nfd/3NFjro=";

  auditable = true; # TODO: remove when this is the default

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang/mdBook";
    changelog = "https://github.com/rust-lang/mdBook/blob/v${version}/CHANGELOG.md";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ havvy Frostman ];
  };
}
