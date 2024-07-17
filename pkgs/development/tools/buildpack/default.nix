{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pack";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nKMgyMPPBon3DChkikNvb2s41osub+fdCeGFzXwhQJo=";
  };

  vendorHash = "sha256-/2GO99kfZTra7tJy90Y0nixNafiP65ZpDQnvEhOaGoA=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/pack" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/buildpacks/pack.Version=${version}"
  ];

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
