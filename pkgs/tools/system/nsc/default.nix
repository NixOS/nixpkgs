{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "nsc";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KNW9meeThHT9ZZJFXsb9RAzLsvgnaXWbuMR4tei/s2U=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.builtBy=nixpkgs"
  ];

  vendorHash = "sha256-3qUgzvb7VkYrlYb+W0ZycJ0S7CQAHSUFNQSfwiKqMdI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nsc \
      --bash <($out/bin/nsc completion bash) \
      --fish <($out/bin/nsc completion fish) \
      --zsh <($out/bin/nsc completion zsh)
  '';

  preInstall = ''
    # asc attempt to write to the home directory.
    export HOME=$(mktemp -d)
  '';

  preCheck = preInstall;

  # Tests currently fail on darwin because of a test in nsc which
  # expects command output to contain a specific path. However
  # the test strips table formatting from the command output in a naive way
  # that removes all the table characters, including '-'.
  # The nix build directory looks something like:
  # /private/tmp/nix-build-nsc-2.8.9.drv-0/nsc_test2000598938/keys
  # Then the `-` are removed from the path unintentionally and the test fails.
  # This should be fixed upstream to avoid mangling the path when
  # removing the table decorations from the command output.
  doCheck = !stdenv.isDarwin;

  meta = {
    description = "Tool for creating NATS account and user access configurations";
    homepage = "https://github.com/nats-io/nsc";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ cbrewster ];
    mainProgram = "nsc";
  };
}
