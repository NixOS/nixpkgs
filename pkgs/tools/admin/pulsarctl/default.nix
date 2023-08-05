{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
, testers
, pulsarctl
}:

buildGoModule rec {
  pname = "pulsarctl";
  version = "2.11.1.3";

  src = fetchFromGitHub {
    owner = "streamnative";
    repo = "pulsarctl";
    rev = "v${version}";
    hash = "sha256-sztjHw3su8KAV/zZcJqPWhjblINa8nYCN5Dzhn6X07w=";
  };

  vendorHash = "sha256-NQ8zvrW6lBF1js+WI2PPvXhv4YRS2IBT6S4vDoE1BFc=";

  nativeBuildInputs = [ installShellFiles ];

  preBuild = let
    buildVars = {
      ReleaseVersion = version;
      BuildTS = "None";
      GitHash = src.rev;
      GitBranch = "None";
      GoVersion = "$(go version | egrep -o 'go[0-9]+[.][^ ]*')";
    };
    buildVarsFlags = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "-X github.com/streamnative/pulsarctl/pkg/cmdutils.${k}=${v}") buildVars);
  in
  ''
    buildFlagsArray+=("-ldflags=${buildVarsFlags}")
  '';

  excludedPackages = [
    "./pkg/test"
    "./pkg/test/bookkeeper"
    "./pkg/test/bookkeeper/containers"
    "./pkg/test/pulsar"
    "./pkg/test/pulsar/containers"
    "./site/gen-pulsarctldocs"
    "./site/gen-pulsarctldocs/generators"
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd pulsarctl \
      --bash <($out/bin/pulsarctl completion bash) \
      --fish <($out/bin/pulsarctl completion fish) \
      --zsh <($out/bin/pulsarctl completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = pulsarctl;
      command = "pulsarctl --version";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = " a CLI for Apache Pulsar written in Go";
    homepage = "https://github.com/streamnative/pulsarctl";
    license = with licenses; [ asl20 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "pulsarctl";
  };
}

