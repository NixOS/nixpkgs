{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-0cyKI8KHFsMXYca3hzbqxmBpxGdhl4/i183kfUQr8pg=";
  };

  cargoHash = "sha256-9dqjNExxLDgVsu14yDQOJP1qxKy2ACiUH+pbX77iT70=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = with maintainers; [
      infinisil
      asymmetric
    ];
    platforms   = platforms.unix;
  };
}
