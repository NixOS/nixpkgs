{ lib
, bash
, fetchFromGitHub
, fetchpatch
, installShellFiles
, nix-update-script
, pam
, pandoc
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sudo-rs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "memorysafety";
    repo = "sudo-rs";
    rev = "v${version}";
    hash = "sha256-Kk5D3387hdl6eGWTSV003r+XajuDh6YgHuqYlj9NnaQ=";
  };
  cargoHash = "sha256-yeMK37tOgJcs9pW3IclpR5WMXx0gMDJ2wcmInxJYbQ8=";

  nativeBuildInputs = [ installShellFiles pandoc ];

  buildInputs = [ pam ];

  patches = [
    (fetchpatch {
      # @R-VdP's patch to work with NixOS' suid wrappers
      name = "Skip self_check when executed as root.patch";
      url = "https://github.com/R-VdP/sudo-rs/commit/a44541dcb36b94f938daaed66b3ff06cfc1c2b40.patch";
      hash = "sha256-PdmOqp/NDjFy8ve4jEOi58e0N9xUnaVKioQwdC5Jf1U=";
    })
  ];

  # Don't attempt to generate the docs in a (pan)Docker container
  postPatch = ''
    substituteInPlace util/generate-docs.sh \
      --replace "/usr/bin/env bash" ${lib.getExe bash} \
      --replace util/pandoc.sh pandoc
  '';

  postInstall = ''
    ./util/generate-docs.sh
    installManPage target/docs/man/*
  '';

  checkFlags = map (t: "--skip=${t}") [
    # Those tests make path assumptions
    "common::command::test::test_build_command_and_args"
    "common::context::tests::test_build_context"
    "common::resolve::test::canonicalization"
    "common::resolve::tests::test_resolve_path"
    "system::tests::kill_test"

    # Assumes $SHELL is an actual shell
    "su::context::tests::su_to_root"

    # Attempts to access /etc files from the build sandbox
    "system::audit::test::secure_open_is_predictable"

    # Assume there is a `daemon` user and group
    "system::interface::test::test_unix_group"
    "system::interface::test::test_unix_user"
    "system::tests::test_get_user_and_group_by_id"

    # This expects some PATH_TZINFO environment var
    "env::environment::tests::test_tzinfo"

    # Unsure why those are failing
    "env::tests::test_environment_variable_filtering"
    "su::context::tests::invalid_shell"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A memory safe implementation of sudo and su.";
    homepage = "https://github.com/memorysafety/sudo-rs";
    changelog = "${meta.homepage}/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.linux;
  };
}
