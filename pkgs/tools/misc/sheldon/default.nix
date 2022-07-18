{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, installShellFiles
, Security
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "sheldon";
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NjNBTjSaFoh+DAJfcM4G3+Meih1czLxs/RMmMwrXqD4=";
  };

  cargoSha256 = "sha256-uRcaHuDLQm6OYqt01kLbW/mfZnL4HaDabaweaw1EOfs=";

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  # Needs network connection
  checkFlags = [
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
