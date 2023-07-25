{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sem";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "semaphoreci";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-L+OdUqhNbCI1UsFvihiKQnmPIzS0mxAKLPVv4u2VP6Y=";
  };

  vendorHash = "sha256-GAYCdq4eHTyxQ5JaNYLd3mQ2LvgLHdmYdz4RN+Hpe70=";
  subPackages = [ "." ];

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  postInstall = ''
    install -m755 $out/bin/cli $out/bin/sem
  '';

  meta = with lib; {
    description = "A cli to operate on semaphore ci (2.0)";
    homepage = "https://github.com/semaphoreci/cli";
    changelog = "https://github.com/semaphoreci/cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ liberatys ];
    platforms = platforms.linux;
  };
}
