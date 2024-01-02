{ buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
, installShellFiles
, testers
, cue
}:

buildGoModule rec {
  pname = "cue";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    hash = "sha256-1svWb83xbVZIlI9pviCYfQ6Kkp0QRjZwrauL7PPJLts=";
  };

  vendorHash = "sha256-ku4tPTXdnKau0kqnAAEHDdSF4oAC/6SDkTq8cECOiEk=";

  patches = [
    # Fix tests with go1.21. See https://github.com/cue-lang/cue/issues/2548.
    (fetchpatch {
      url = "https://github.com/cue-lang/cue/commit/3bf3dbd655284d3628399a83a703f4849b5f9374.patch";
      hash = "sha256-9Zi2mrqB1JTFvadiqWTgzzi1pffZ3gOmTtrDDQWye1Q=";
    })
  ];

  postPatch = ''
    # Disable script tests
    rm -f cmd/cue/cmd/script_test.go
  '';

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
