{ buildGoModule
, fetchFromGitHub
, lib
, installShellFiles
, testers
, cue
}:

buildGoModule rec {
  pname = "cue";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    hash = "sha256-L2KEOnUmQ6K+VtyJEha0LBWPVt+FqNh94gi3cMg82x0=";
  };

  vendorHash = "sha256-Eq51sydt2eu3pSCRjepvxpU01T0vr0axx9XEk34db28=";

  subPackages = [ "cmd/cue" ];

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
