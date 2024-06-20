{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sem";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "semaphoreci";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-ZizmDuEu3D8cVOMw0k1yBXlLft+nzOPnqv5Yi6vk5AM=";
  };

  vendorHash = "sha256-p8+M+pRp12P7tYlFpXjU94JcJOugQpD8rFdowhonh74=";
  subPackages = [ "." ];

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  postInstall = ''
    install -m755 $out/bin/cli $out/bin/sem
  '';

  meta = with lib; {
    description = "Cli to operate on semaphore ci (2.0)";
    homepage = "https://github.com/semaphoreci/cli";
    changelog = "https://github.com/semaphoreci/cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ liberatys ];
    platforms = platforms.linux;
  };
}
