{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, libgit2
, pkg-config
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  # unstable was used for a quick fix for darwin
  # revert to stable for the release after 1.5.4
  version = "unstable-2022-04-12";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "a02e87833d6a0e0da3c239d0bbbf3b485356a655";
    sha256 = "sha256-oe/dKFgM8h+ur8E9/dw4byBl9vD6foUXyKX19HDozYU=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ libgit2 ] ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation Cocoa ];

  buildNoDefaultFeatures = true;
  # the "notify" feature is currently broken on darwin
  buildFeatures = if stdenv.isDarwin then [ "battery" ] else [ "default" ];

  postInstall = ''
    for shell in bash fish zsh; do
      STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "sha256-lku+K1Y5HIt4gDHqudhDMVs7XGoKw8HcMjXMGDu1vkg=";

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
  };
}
