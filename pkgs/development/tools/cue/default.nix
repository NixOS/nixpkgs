{ buildGoModule, fetchFromGitHub, lib, installShellFiles, testers, cue }:

buildGoModule rec {
  pname = "cue";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    hash = "sha256-1svWb83xbVZIlI9pviCYfQ6Kkp0QRjZwrauL7PPJLts=";
  };

  postPatch = ''
    # Disable script tests
    rm -f cmd/cue/cmd/script_test.go
  '';

  vendorHash = "sha256-ku4tPTXdnKau0kqnAAEHDdSF4oAC/6SDkTq8cECOiEk=";

  excludedPackages = [ "internal/ci/updatetxtar" "internal/cmd/embedpkg" "internal/cmd/qgo" "pkg/gen" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X cuelang.org/go/cmd/cue/cmd.version=${version}" ];

  postInstall = ''
    # Completions
    installShellCompletion --cmd cue \
      --bash <($out/bin/cue completion bash) \
      --fish <($out/bin/cue completion fish) \
      --zsh <($out/bin/cue completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/cue eval - <<<'a: "all good"' > /dev/null
  '';

  passthru.tests.version = testers.testVersion {
    package = cue;
    command = "cue version";
  };

  meta = with lib;  {
    description = "A data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
