{ lib, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, lvm2 }:

buildGoModule rec {
  pname = "dockle";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "goodwithtech";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Zc2ZlyeWdRvyuJLDDTONfh0/q+HKR4lNtSFMjgJWrRY=";
  };

  vendorSha256 = "sha256-4IJKXcnMXBqoEjsV4Xg2QYvKwxDDUjcZtrj9IRuT6i4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ btrfs-progs lvm2 ];

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    # Remove tests that use networking
    rm pkg/scanner/scan_test.go pkg/utils/fetch_test.go
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
