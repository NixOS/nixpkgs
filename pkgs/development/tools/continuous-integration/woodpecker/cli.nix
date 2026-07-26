{
  buildGoModule,
  callPackage,
  installShellFiles,
  lib,
  stdenv,
}:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-cli";
  inherit (common)
    version
    src
    ldflags
    vendorHash
    ;

  subPackages = "cmd/cli";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;
  postInstall = ''
    ${common.postInstall}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd woodpecker-cli \
      --bash <($out/bin/woodpecker-cli completion bash) \
      --fish <($out/bin/woodpecker-cli completion fish ) \
      --zsh <($out/bin/woodpecker-cli completion zsh)
  '';

  meta = common.meta // {
    description = "Command line client for the Woodpecker Continuous Integration server";
    mainProgram = "woodpecker-cli";
  };
}
