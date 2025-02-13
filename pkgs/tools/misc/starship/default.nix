{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cmake,
  git,
  nixosTests,
  Security,
  Foundation,
  Cocoa,
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    hash = "sha256-YoLi4wxBK9TFTtZRm+2N8HO5ZiC3V2GMqKFKKLHq++s=";
  };

  nativeBuildInputs = [
    installShellFiles
    cmake
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
    Foundation
    Cocoa
  ];

  NIX_LDFLAGS = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-framework"
    "AppKit"
  ];

  # tries to access HOME only in aarch64-darwin environment when building mac-notification-sys
  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    export HOME=$TMPDIR
  '';

  postInstall =
    ''
      presetdir=$out/share/starship/presets/
      mkdir -p $presetdir
      cp docs/public/presets/toml/*.toml $presetdir
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd starship \
        --bash <($out/bin/starship completions bash) \
        --fish <($out/bin/starship completions fish) \
        --zsh <($out/bin/starship completions zsh)
    '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-B2CCrSH2aTcGEX96oBxl/27hNMdDpdd2vxdt0/nlN6I=";

  nativeCheckInputs = [ git ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "Minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [
      danth
      davidtwco
      Br1ght0ne
      Frostman
    ];
    mainProgram = "starship";
  };
}
