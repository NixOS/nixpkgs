{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rome";
  version = "12.1.3";

  src = fetchFromGitHub {
    owner = "rome";
    repo = "tools";
    rev = "cli/v${version}";
    hash = "sha256-BlHpdfbyx6nU44vasEw0gRZ0ickyD2eUXPfeFZHSCbI=";
  };

  cargoHash = "sha256-jHdoRymKPjBonT4TvAiTNzGBuTcNoPsvdFKEf33dpVc=";

  cargoBuildFlags = [ "--package" "rome_cli" ];

  env = {
    RUSTFLAGS = "-C strip=symbols";
    ROME_VERSION = version;
  };

  buildInputs =
    lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeBuildInputs = [ pkg-config ];

  # need to manually unset the ROME_VERSION before checkPhase otherwise some tests fail
  preCheck = ''
    unset ROME_VERSION;
  '';

  # these test fail
  checkFlags = [
    "--skip parser::tests::uncompleted_markers_panic"
    "--skip commands::check::fs_error_infinite_symlink_exapansion"
    "--skip commands::check::fs_error_dereferenced_symlink"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "cli%2Fv(.*)" ];
  };

  meta = with lib; {
    description = "A formatter, linter, bundler, and more for JavaScript, TypeScript, JSON, HTML, Markdown, and CSS";
    homepage = "https://rome.tools";
    changelog = "https://github.com/rome/tools/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya felschr ];
  };
}
