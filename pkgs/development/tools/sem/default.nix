{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sem";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "semaphoreci";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-pyin05mPIAq5dJebLehsCYDaIf5eGCcGzF5uz8egJV8=";
  };

  vendorSha256 = "sha256-kuLN3r6CGL/fGQ5ggSLZWNC4AVvvGn6znTFGqkS4AXg=";
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
