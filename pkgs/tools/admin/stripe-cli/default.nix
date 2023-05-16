{ lib, buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "stripe-cli";
<<<<<<< HEAD
  version = "1.17.2";
=======
  version = "1.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MzzjrGtqbtZMvfL7dPAsKHF2ZTneSdtDuwHQQcyrQDw=";
  };
  vendorHash = "sha256-DYA6cu2KzEBZ4wsT7wjcdY1endQQOZlj2aOwu6iGLew=";
=======
    hash = "sha256-zP5QR1K8BAga+dEqGZKpZRYrpNLIBm6RNdf9VD9PaCk=";
  };
  vendorHash = "sha256-rjYV69BWkqIkgyeauAo4KEfbB7cxnwn3VSjLrMrCu1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stripe/stripe-cli/pkg/version.Version=${version}"
  ];

  preCheck = ''
    # the tests expect the Version ldflag not to be set
    unset ldflags

    # requires internet access
    rm pkg/cmd/plugin_cmds_test.go
    rm pkg/cmd/resources_test.go
    rm pkg/cmd/root_test.go

<<<<<<< HEAD
    # TODO: no clue why it's broken (1.17.1), remove for now.
=======
    # TODO: no clue why it's broken (1.14.1), remove for now.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rm pkg/login/client_login_test.go
    rm pkg/git/editor_test.go
    rm pkg/rpcservice/sample_create_test.go
  '' + lib.optionalString (
      # delete plugin tests on all platforms but exact matches
      # https://github.com/stripe/stripe-cli/issues/850
      ! lib.lists.any
        (platform: lib.meta.platformMatch stdenv.hostPlatform platform)
        [ "x86_64-linux" "x86_64-darwin" ]
  ) ''
    rm pkg/plugins/plugin_test.go
  '';

  postInstall = ''
    installShellCompletion --cmd stripe \
      --bash <($out/bin/stripe completion --write-to-stdout --shell bash) \
      --zsh <($out/bin/stripe completion --write-to-stdout --shell zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/stripe --help
    $out/bin/stripe --version | grep "${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://stripe.com/docs/stripe-cli";
    changelog = "https://github.com/stripe/stripe-cli/releases/tag/v${version}";
    description = "A command-line tool for Stripe";
    longDescription = ''
      The Stripe CLI helps you build, test, and manage your Stripe integration
      right from the terminal.

      With the CLI, you can:
      Securely test webhooks without relying on 3rd party software
      Trigger webhook events or resend events for easy testing
      Tail your API request logs in real-time
      Create, retrieve, update, or delete API objects.
    '';
    license = with licenses; [ asl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ RaghavSood jk kashw2 ];
=======
    maintainers = with maintainers; [ RaghavSood jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "stripe";
  };
}
