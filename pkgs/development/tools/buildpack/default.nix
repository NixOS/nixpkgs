{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pack";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G1tnk0SlQVX4bEifmuZahazNv3bbdgmcr1V0dN9dlKc=";
  };

  vendorSha256 = "sha256-jeOK4k1W/5LvqB52LriKD5jNvZa/nc2ypRowrem2y30=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/pack" ];

  ldflags = [ "-s" "-w" "-X github.com/buildpacks/pack.Version=${version}" ];

  postInstall = ''
    installShellCompletion --bash --name pack.bash $(PACK_HOME=$PWD $out/bin/pack completion --shell bash)
    installShellCompletion --zsh --name _pack $(PACK_HOME=$PWD $out/bin/pack completion --shell zsh)
  '';

  meta = with lib; {
    homepage = "https://buildpacks.io/";
    changelog = "https://github.com/buildpacks/pack/releases/tag/v${version}";
    description = "CLI for building apps using Cloud Native Buildpacks";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
