{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "thanos";
  version = "0.31.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thanos-io";
    repo = "thanos";
    sha256 = "sha256-EJZGc4thu0WhVSSRolIRYg39S81Cgm+JHwpW5eE7mDc=";
  };

  vendorHash = "sha256-bNQwDttJ7YuQFrpp0alqe37/lue0CX5gB2UDRWWtTXQ=";

  doCheck = false;

  subPackages = "cmd/thanos";

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=unknown"
    "-X ${t}.Branch=unknown"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
  ];

  meta = with lib; {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = "https://github.com/thanos-io/thanos";
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.unix;
  };
}
