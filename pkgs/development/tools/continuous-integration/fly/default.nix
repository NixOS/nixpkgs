{ buildGoModule, fetchFromGitHub, stdenv, lib, installShellFiles }:

buildGoModule rec {
  pname = "fly";
<<<<<<< HEAD
  version = "7.10.0";
=======
  version = "7.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KmKIr7Y3CQmv1rXdju6xwUHABqj/dkXpgWc/yNrAza8=";
  };

  vendorHash = "sha256-lc0okniezfTNLsnCBIABQxSgakRUidsprrEnkH8il2g=";
=======
    sha256 = "sha256-ySyarky92+VSo/KzQFrWeh35KDMTQDV34F5iFrARHJs=";
  };

  vendorHash = "sha256-Oy1wP82ZhdpGHs/gpfdveOK/jI9yuo0D3JtxjLg+W/w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "fly" ];

  ldflags = [
    "-s" "-w" "-X github.com/concourse/concourse.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fly \
      --bash <($out/bin/fly completion --shell bash) \
      --fish <($out/bin/fly completion --shell fish) \
      --zsh <($out/bin/fly completion --shell zsh)
  '';

  meta = with lib; {
    description = "Command line interface to Concourse CI";
    homepage = "https://concourse-ci.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivanbrennan SuperSandro2000 ];
  };
}
