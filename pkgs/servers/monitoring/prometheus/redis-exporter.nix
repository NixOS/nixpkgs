{ lib, buildGoModule, fetchFromGitHub, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-NvkAwUrygjys25lcTxtRnrex4+XIK2yzqKkk26f4cmE=";
  };

  patches = [
    # https://github.com/oliver006/redis_exporter/pull/812
    (fetchpatch {
      url = "https://github.com/Ma27/redis_exporter/commit/250b2e9febbadef326ca9ae68c372dfaabd53ca9.patch";
      sha256 = "sha256-G1OIUwlFZ06UWudWvc6v1YFcRz05ji1326nUcd9zYDc=";
    })
  ];

  vendorHash = "sha256-S7cEaFBgyvDmsNq+NvqtC8I2SRL/ngXUuNdx6TN/riI=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a redis server
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) redis; };

  meta = with lib; {
    description = "Prometheus exporter for Redis metrics";
    homepage = "https://github.com/oliver006/redis_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ma27 ];
  };
}
