{ lib, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, lvm2 }:

buildGoModule rec {
  pname = "dockle";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "goodwithtech";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U0nIGuQ4QjBaCck0Kg1RTS2IQwfivN3VI5vxh8lxAYE=";
  };

  vendorSha256 = "sha256-uHHm4AgnjTdPgpu3OpXXIRzrGhkpOoRY8qynfl7DO6w=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ btrfs-progs lvm2 ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X main.version=${version}")
  '';

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
