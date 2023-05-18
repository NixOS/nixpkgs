{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rome";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "rome";
    repo = "tools";
    rev = "cli/v${version}";
    hash = "sha256-XORu6c/9jrRObdM3qAGszhiUjo88NTzrTyrITuHyd/4=";
  };

  cargoHash = "sha256-75r280PMM1zDrqRmhuaU++5aZSCxeyqjHQls8pTzOgQ=";

  cargoBuildFlags = [ "--package" "rome_cli" ];

  env = {
    RUSTFLAGS = "-C strip=symbols";
    ROME_VERSION = "${version}";
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

  meta = with lib; {
    description = "A formatter, linter, bundler, and more for JavaScript, TypeScript, JSON, HTML, Markdown, and CSS";
    homepage = "https://rome.tools";
    changelog = "https://github.com/rome/tools/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya felschr ];
  };
}
