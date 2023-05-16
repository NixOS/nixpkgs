{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pack";
<<<<<<< HEAD
  version = "0.30.0";
=======
  version = "0.29.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-o9c1MUxyZpqk10UbW5y9JqX2Z62K7hDeSEiFGIUnoAs=";
  };

  vendorHash = "sha256-k2ZgFjSO3yHS0pO7xZx6a5E4J35ou2AmjbiV2M9OGTk=";
=======
    hash = "sha256-A/LGn+CiqDja0gDuvydvu/fRJozrlnSV62kPjUdwEH8=";
  };

  vendorHash = "sha256-tiYF5Ni6GHRV3JdUkP6155lDN3NGId9/sA/iZSiD1II=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
