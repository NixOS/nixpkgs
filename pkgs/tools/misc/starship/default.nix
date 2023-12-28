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
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Hf9tW1oBAw8/1KIRZpIpyVaEitLkVr2v6ilTHREzwvU=";
  };

  nativeBuildInputs = [ installShellFiles cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security Foundation Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)

    presetdir=$out/share/starship/presets/
    mkdir -p $presetdir
    cp docs/.vuepress/public/presets/toml/*.toml $presetdir
  '';

  cargoHash = "sha256-OENey+brI3B2CThNm1KOxuX/OO8tHb7i5X0jXit7FrU=";

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
