{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:
buildGoModule rec {
  pname = "thanos";
  version = "0.31.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thanos-io";
    repo = "thanos";
    sha256 = "sha256-EJZGc4thu0WhVSSRolIRYg39S81Cgm+JHwpW5eE7mDc=";
  };

  patches = [
    # https://github.com/thanos-io/thanos/pull/6126
    (fetchpatch {
      url = "https://github.com/thanos-io/thanos/commit/a4c218bd690259fc0c78fe67e0739bd33d38541e.patch";
      hash = "sha256-Hxc1s5IXAyw01/o4JvOXuyYuOFy0+cBUv3OkRv4DCXs=";
    })
  ];

  vendorHash = "sha256-8+MUMux6v/O2syVyTx758yUBfJkertzibz6yFB05nWk=";

  doCheck = true;

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
  };
}
