{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "argocd-vault-plugin";
<<<<<<< HEAD
  version = "1.16.1";
=======
  version = "1.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7bUpshg+OqlS5wvFkZkovQVaLglvSpp7FsVA9qNOk1U=";
  };

  vendorHash = "sha256-r9Pcm95gU0QTiREdiQiyJMOKZb5Lt2bIJywLerzgbdg=";
=======
    hash = "sha256-TIZpeCYj8i/RbWqYn6js70QtQsnAF0itHCs+2mjwuGg=";
  };

  vendorHash = "sha256-awa3hbM9/9YR7amx/VVOEWgzK/l8OjOemDFpYojfOwg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # integration tests require filesystem and network access for credentials
  doCheck = false;

  meta = with lib; {
    homepage = "https://argocd-vault-plugin.readthedocs.io";
    changelog = "https://github.com/argoproj-labs/argocd-vault-plugin/releases/tag/v${version}";
    description = "An Argo CD plugin to retrieve secrets from Secret Management tools and inject them into Kubernetes secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
