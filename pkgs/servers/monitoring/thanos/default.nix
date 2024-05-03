{ lib
, buildGoModule
, fetchFromGitHub
, go
, nix-update-script
, nixosTests
, testers
, thanos
}:

buildGoModule rec {
  pname = "thanos";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "thanos-io";
    repo = "thanos";
    rev = "refs/tags/v${version}";
    hash = "sha256-optV6g3R0W4SP5BJgUOyya+VHHRWrsz5XS7zGuKcN6k=";
  };

  vendorHash = "sha256-i8EGUxNbxfyPQ3BVa7yBR1ygHIC64v6m/aDGFzWWfIE=";

  doCheck = true;

  subPackages = "cmd/thanos";

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=unknown"
    "-X ${t}.Branch=unknown"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
    "-X ${t}.GoVersion=${lib.getVersion go}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) prometheus;
      version = testers.testVersion {
        command = "thanos --version";
        package = thanos;
      };
    };
  };

  meta = with lib; {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    changelog = "https://github.com/thanos-io/thanos/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "thanos";
    maintainers = with maintainers; [ basvandijk anthonyroussel ];
  };
}
