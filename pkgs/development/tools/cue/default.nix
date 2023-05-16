{ buildGoModule, fetchFromGitHub, lib, installShellFiles, testers, cue }:

buildGoModule rec {
  pname = "cue";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1svWb83xbVZIlI9pviCYfQ6Kkp0QRjZwrauL7PPJLts=";
=======
    hash = "sha256-4E50VrekIkVXhzHVNehgm6/DbkofvqlNSgX9oK9SLu4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Disable script tests
    rm -f cmd/cue/cmd/script_test.go
  '';

<<<<<<< HEAD
  vendorHash = "sha256-ku4tPTXdnKau0kqnAAEHDdSF4oAC/6SDkTq8cECOiEk=";
=======
  vendorHash = "sha256-0N0bZdimGHu3vkLe+eGKBTm/YeSQOnp+Pxhz3LVniTk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
