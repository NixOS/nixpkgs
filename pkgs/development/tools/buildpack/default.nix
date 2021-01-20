{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pack";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    sha256 = "026qy81hfblx98z9hip7gpqcfqgzfhm5bimg6p9gi5fd5wsbfs4c";
  };

  vendorSha256 = "0i6nplh1papcmdzas9f8pkccsx5csbxxkvy5a6130jjbwdm14jw7";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/pack" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/buildpacks/pack.Version=${version}" ];

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
