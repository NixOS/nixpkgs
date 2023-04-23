{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
, xvfb-run
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "14.0.1";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mfeHgUCnt/DkdKxFlYx/t2LLjiqDX5mBMHto9A4mj78=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash = if stdenv.isLinux then "sha256-oaBTj+ZSJ36AFwIrB6d0cZppoAzV4QDr3+EylYqY7cw=" else "sha256-UNuoW/EOGtuNROm1qZJ4afDfMlecziVsem1m3Z1ZsOU=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  nativeCheckInputs = lib.optionals xvfb-run.meta.available [
    xvfb-run
  ];

  checkPhase = lib.optionalString xvfb-run.meta.available ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

  passthru.tests = {
    inherit (nixosTests) atuin;
  };

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 sciencentistguy _0x4A6F ];
  };
}
