{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pack";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y6weRD3MrWEL/KYBMb/bJd6NKfcRELG+RQAhmh/gsuo=";
  };

  vendorHash = "sha256-gp6Hd0MZxtUX0yYshFIGwrm6yY2pdSOtUs6xmzXBqc4=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/pack" ];

  ldflags = [ "-s" "-w" "-X github.com/buildpacks/pack.Version=${version}" ];

  postInstall = ''
    installShellCompletion --cmd pack \
      --zsh $(PACK_HOME=$PWD $out/bin/pack completion --shell zsh) \
      --bash $(PACK_HOME=$PWD $out/bin/pack completion --shell bash) \
      --fish $(PACK_HOME=$PWD $out/bin/pack completion --shell fish)
  '';

  meta = with lib; {
    homepage = "https://buildpacks.io/";
    changelog = "https://github.com/buildpacks/pack/releases/tag/v${version}";
    description = "CLI for building apps using Cloud Native Buildpacks";
    mainProgram = "pack";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
