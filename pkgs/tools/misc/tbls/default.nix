{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, tbls
}:

buildGoModule rec {
  pname = "tbls";
  version = "1.77.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-knYAwmxqeHv1XBi/zHf7cOkcLXITGnX0tXlT8/Zs2YQ=";
  };

  vendorHash = "sha256-m5G0knHmPCz1pZ7LZ4i6Tyq+xSEq32mQFbXEdOY+6ec=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  CGO_CFLAGS = [ "-Wno-format-security" ];

  preCheck = ''
    # Remove tests that require additional services.
    rm -f \
       datasource/*_test.go \
       drivers/*/*_test.go
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tbls \
      --bash <($out/bin/tbls completion bash) \
      --fish <($out/bin/tbls completion fish) \
      --zsh <($out/bin/tbls completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = tbls;
    command = "tbls version";
    inherit version;
  };

  meta = with lib; {
    description = "Tool to generate documentation based on a database structure";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "tbls";
  };
}
