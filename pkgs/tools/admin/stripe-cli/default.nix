{ lib, buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.19.5";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gunLbZOT0cnWGxc6714XcPdHJVK4LbDBwC2zt03WrUM=";
  };
  vendorHash = "sha256-xFWU+OazwLTb5qdFeYth1MlPJ76nEK4qSCNGVhC/PxE=";

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

    # TODO: no clue why it's broken (1.17.1), remove for now.
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
    maintainers = with maintainers; [ RaghavSood jk kashw2 ];
    mainProgram = "stripe";
  };
}
