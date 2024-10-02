{ lib
, nix-update-script
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, coreutils
, bash
, pkg-config
, openssl
, direnv
, Security
, SystemConfiguration
, mise
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2024.9.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-q515JEpws1UnZm1b8zgGxPvudH846XV+Ct4qKN2mNMQ=";

    # registry is not needed for compilation nor for tests.
    # contains files with the same name but different case, which cause problems with hash on darwin
    postFetch = ''
      rm -rf $out/registry
    '';
  };

  cargoHash = "sha256-jGqaGbue+AEK0YjhHMlm84XBgA20p8Um03TjctjXVz0=";

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security SystemConfiguration ];

  postPatch = ''
    patchShebangs --build \
      ./test/data/plugins/**/bin/* \
      ./src/fake_asdf.rs \
      ./src/cli/generate/git_pre_commit.rs \
      ./src/cli/generate/snapshots/*.snap \
      ./src/cli/reshim.rs \
      ./test/cwd/.mise/tasks/filetask

    substituteInPlace ./src/test.rs \
      --replace-fail '/usr/bin/env bash' '${bash}/bin/bash'

    substituteInPlace ./src/env_diff.rs \
      --replace-fail '"bash"' '"${bash}/bin/bash"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-fail '"env"' '"${coreutils}/bin/env"' \
      --replace-fail 'cmd!("direnv"' 'cmd!("${direnv}/bin/direnv"'
  '';

  checkFlags = [
    # Requires .git directory to be present
    "--skip=cli::plugins::ls::tests::test_plugin_list_urls"
    "--skip=cli::generate::git_pre_commit::tests::test_git_pre_commit"
    "--skip=cli::generate::github_action::tests::test_github_action"
  ];
  cargoTestFlags = [ "--all-features" ];
  # some tests access the same folders, don't test in parallel to avoid race conditions
  dontUseCargoParallelTests = true;

  postInstall = ''
    installManPage ./man/man1/mise.1

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mise; };
  };

  meta = {
    homepage = "https://mise.jdx.dev";
    description = "Front-end to your dev env";
    changelog = "https://github.com/jdx/mise/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "mise";
  };
}
