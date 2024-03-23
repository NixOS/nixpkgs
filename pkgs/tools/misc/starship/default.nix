{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, cmake
, git
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    hash = "sha256-f9alFoTH461y1EYnhxnnPN98ujLTnlVBJa8lEp8t44Y=";
  };

  nativeBuildInputs = [ installShellFiles cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security Foundation Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  # tries to access HOME only in aarch64-darwin environment when building mac-notification-sys
  preBuild = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)

    presetdir=$out/share/starship/presets/
    mkdir -p $presetdir
    cp docs/public/presets/toml/*.toml $presetdir
  '';

  cargoHash = "sha256-7k7qb5jLz2mk27ayYYE5uFXYgQkjbIIwdppJxM8YgtY=";

  nativeCheckInputs = [ git ];

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
    maintainers = with maintainers; [ danth davidtwco Br1ght0ne Frostman marsam ];
    mainProgram = "starship";
  };
}
