{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
<<<<<<< HEAD
=======
, xvfb-run
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
<<<<<<< HEAD
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    rev = "v${version}";
    hash = "sha256-Kh6aaWYV+ZG7Asvw5JdGsV+nxD+xvvQab5wLIedcQcQ=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux
    then "sha256-Ami88ScGj58jCCat4MMDvjZtV5WglmrlggpQfo+LPjs="
    else "sha256-HQMZ9w1C6go16XGrPNniQZliIQ/5yAp2w/uUwAOQTM0=";
=======
  version = "14.0.1";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mfeHgUCnt/DkdKxFlYx/t2LLjiqDX5mBMHto9A4mj78=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash = if stdenv.isLinux then "sha256-oaBTj+ZSJ36AFwIrB6d0cZppoAzV4QDr3+EylYqY7cw=" else "sha256-UNuoW/EOGtuNROm1qZJ4afDfMlecziVsem1m3Z1ZsOU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

<<<<<<< HEAD
=======
  nativeCheckInputs = lib.optionals xvfb-run.meta.available [
    xvfb-run
  ];

  checkPhase = lib.optionalString xvfb-run.meta.available ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests = {
    inherit (nixosTests) atuin;
  };

<<<<<<< HEAD
  checkFlags = [
    # tries to make a network access
    "--skip=registration"
  ];

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
=======
  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 sciencentistguy _0x4A6F ];
  };
}
