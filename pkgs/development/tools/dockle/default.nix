{ lib, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, lvm2 }:

buildGoModule rec {
  pname = "dockle";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "goodwithtech";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-45VRA3IBGlbMoRbAh6F+KuAM5CIlU00ZzG7N62aikGE=";
  };

  vendorHash = "sha256-t66SRFDJT32dwRFqborir+mSQJlpekbicDNhmkeqork=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ btrfs-progs lvm2 ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goodwithtech/dockle/pkg.version=${version}"
  ];

  preCheck = ''
    # Remove tests that use networking
    rm pkg/scanner/scan_test.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/dockle --help
    $out/bin/dockle --version | grep "dockle version ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://containers.goodwith.tech";
    changelog = "https://github.com/goodwithtech/dockle/releases/tag/v${version}";
    description = "Container Image Linter for Security";
    longDescription = ''
      Container Image Linter for Security.
      Helping build the Best-Practice Docker Image.
      Easy to start.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
