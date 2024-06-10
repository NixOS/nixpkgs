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
  version = "1.76.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
    hash = "sha256-tVilEpSmCHx+m8HwcsyNDVIUICccndnn4vI4oOa5t/w=";
  };

  vendorHash = "sha256-ALjpU5el6Tmzsw2f5/AizFBuk+zJj9RKe9KHdE0AOrM=";

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
