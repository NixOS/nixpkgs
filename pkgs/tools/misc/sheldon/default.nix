{ lib
, stdenv
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchCrate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rustPlatform
, pkg-config
, openssl
, installShellFiles
, Security
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "sheldon";
<<<<<<< HEAD
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "rossmacarthur";
    repo = pname;
    rev = version;
    hash = "sha256-vGFR8NL3bOCUuNr0KQuAbjQMxvFbN/T9aVmf7Wxt9JU=";
  };

  cargoSha256 = "sha256-wVB+yL+h90f7NnASDaX5gxT5z45M8I1rxIJwY8uyB4k=";
=======
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NjNBTjSaFoh+DAJfcM4G3+Meih1czLxs/RMmMwrXqD4=";
  };

  cargoSha256 = "sha256-uRcaHuDLQm6OYqt01kLbW/mfZnL4HaDabaweaw1EOfs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  # Needs network connection
  checkFlags = [
<<<<<<< HEAD
    "--skip lock::plugin::tests::external_plugin_lock_git_with_matches"
    "--skip lock::plugin::tests::external_plugin_lock_git_with_matches_not_each"
    "--skip lock::plugin::tests::external_plugin_lock_git_with_uses"
    "--skip lock::plugin::tests::external_plugin_lock_remote"
    "--skip lock::source::git::tests::git_checkout_resolve_branch"
    "--skip lock::source::git::tests::git_checkout_resolve_rev"
    "--skip lock::source::git::tests::git_checkout_resolve_tag"
    "--skip lock::source::git::tests::lock_git_and_reinstall"
    "--skip lock::source::git::tests::lock_git_https_with_checkout"
    "--skip lock::source::local::tests::lock_local"
    "--skip lock::source::remote::tests::lock_remote_and_reinstall"
    "--skip lock::source::tests::lock_with_git"
    "--skip lock::source::tests::lock_with_remote"
    "--skip lock::tests::locked_config_clean"
    "--skip directories_default"
    "--skip directories_old"
    "--skip directories_xdg_from_env"
    "--skip lock_and_source_github"
    "--skip lock_and_source_hooks"
    "--skip lock_and_source_inline"
    "--skip lock_and_source_profiles"
=======
    "--skip cli::tests::raw_opt_help"
    "--skip lock::tests::external_plugin_lock_git_with_matches"
    "--skip lock::tests::external_plugin_lock_git_with_matches_error"
    "--skip lock::tests::external_plugin_lock_git_with_matches_not_each"
    "--skip lock::tests::external_plugin_lock_git_with_uses"
    "--skip lock::tests::external_plugin_lock_remote"
    "--skip lock::tests::git_checkout_resolve_branch"
    "--skip lock::tests::git_checkout_resolve_rev"
    "--skip lock::tests::git_checkout_resolve_tag"
    "--skip lock::tests::locked_config_clean"
    "--skip lock::tests::source_lock_git_and_reinstall"
    "--skip lock::tests::source_lock_git_git_with_checkout"
    "--skip lock::tests::source_lock_git_https_with_checkout"
    "--skip lock::tests::source_lock_local"
    "--skip lock::tests::source_lock_remote_and_reinstall"
    "--skip lock::tests::source_lock_with_git"
    "--skip lock::tests::source_lock_with_remote"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    installShellCompletion --cmd sheldon \
      --bash <($out/bin/sheldon completions --shell bash) \
      --zsh <($out/bin/sheldon completions --shell zsh)
  '';

  meta = with lib; {
    description = "A fast and configurable shell plugin manager";
    homepage = "https://github.com/rossmacarthur/sheldon";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ seqizz ];
    platforms = platforms.linux;
  };
}
