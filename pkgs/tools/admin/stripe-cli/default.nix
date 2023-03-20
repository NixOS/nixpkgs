{ lib, buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jos6SZ2ZkUeWOM0ALlsc5a+5kcullNF/2AknTQpRnIc=";
  };
  vendorSha256 = "sha256-1c+YtfRy1ey0z117YHHkrCnpb7g+DmM+LR1rjn1YwMQ=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stripe/stripe-cli/pkg/version.Version=${version}"
  ];

  preCheck = ''
    # the tests expect the Version ldflag not to be set
    unset ldflags
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
    maintainers = with maintainers; [ RaghavSood jk ];
    mainProgram = "stripe";
  };
}
