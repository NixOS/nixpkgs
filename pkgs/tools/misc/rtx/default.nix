{ lib
, nix-update-script
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, coreutils
, bash
, direnv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rtx";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "jdxcode";
    repo = "rtx";
    rev = "v${version}";
    sha256 = "sha256-ePRYlTGgZDrIClZ4kb9v62/FiLzZT6DzL3kaY6eAq5g=";
  };

  cargoSha256 = "sha256-RFAIc4KfMvxz2BYX8x8j8T5evMqFP8ML4+wHwWdODVk=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postPatch = ''
    patchShebangs --build ./test/data/plugins/**/bin/* ./src/fake_asdf.rs ./src/cli/reshim.rs

    substituteInPlace ./src/env_diff.rs \
      --replace '"bash"' '"${bash}/bin/bash"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace '"env"' '"${coreutils}/bin/env"' \
      --replace 'cmd!("direnv"' 'cmd!("${direnv}/bin/direnv"'
  '';

  checkFlags = [
    # Requires .git directory to be present
    "--skip=cli::plugins::ls::tests::test_plugin_list_urls"
  ];
  cargoTestFlags = [ "--all-features" ];
  # some tests access the same folders, don't test in parallel to avoid race conditions
  dontUseCargoParallelTests = true;

  postInstall = ''
    installManPage ./man/man1/rtx.1

    installShellCompletion \
      --bash ./completions/rtx.bash \
      --fish ./completions/rtx.fish \
      --zsh ./completions/_rtx
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/jdxcode/rtx";
    description = "Polyglot runtime manager (asdf rust clone)";
    changelog = "https://github.com/jdxcode/rtx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
  };
}
