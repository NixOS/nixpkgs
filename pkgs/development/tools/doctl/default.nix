{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, buildPackages }:

buildGoModule rec {
  pname = "doctl";
<<<<<<< HEAD
  version = "1.98.0";
=======
  version = "1.94.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  vendorHash = null;

  doCheck = false;

  subPackages = [ "cmd/doctl" ];

  ldflags = let t = "github.com/digitalocean/doctl"; in [
    "-X ${t}.Major=${lib.versions.major version}"
    "-X ${t}.Minor=${lib.versions.minor version}"
    "-X ${t}.Patch=${lib.versions.patch version}"
    "-X ${t}.Label=release"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    export HOME=$(mktemp -d) # attempts to write to /homeless-shelter
    for shell in bash fish zsh; do
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/doctl completion $shell > doctl.$shell
      installShellCompletion doctl.$shell
    done
  '';

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "doctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-M9kSQoYcJudL/y/Yc6enVT/rJusd+oe3BdjkaLRQ0gU=";
=======
    sha256 = "sha256-R/dy//e+DfyANoNtiPoAI9CF7k8ZviFgsnMrWryf0LY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "A command line tool for DigitalOcean services";
    homepage = "https://github.com/digitalocean/doctl";
    license = licenses.asl20;
    maintainers = [ maintainers.siddharthist ];
  };
}
