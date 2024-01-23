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
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "thanos-io";
    repo = "thanos";
    rev = "refs/tags/v${version}";
    hash = "sha256-AM4gJmUea8/Rfg7i4yTIK1ie+8MHz0M+ZG2F//wYHNA=";
  };

  vendorHash = "sha256-JLj0HhcT4Hlc/FpYNGasqbfNz4cV12UueCYuXjamxks=";

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
