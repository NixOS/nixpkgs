{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "nsc";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uJR4AdXGSL3vKUABpBBteND7EUocKz+mLRqt5XPdREk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.builtBy=nixpkgs"
  ];

  vendorHash = "sha256-+XSG5vDEGUYlORF9a15QnE2pueU8GN+UF7w7EtRArG8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd nsc \
      --bash <($out/bin/nsc completion bash) \
      --fish <($out/bin/nsc completion fish) \
      --zsh <($out/bin/nsc completion zsh)
  '';

  preCheck = ''
    # Tests attempt to write to the home directory.
    export HOME=$(mktemp -d)
  '';

  # Tests currently fail on darwin because of a test in nsc which
  # expects command output to contain a specific path. However
  # the test strips table formatting from the command output in a naive way
  # that removes all the table characters, including '-'.
  # The nix build directory looks something like:
  # /private/tmp/nix-build-nsc-2.8.7.drv-0/nsc_test2000598938/keys
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
