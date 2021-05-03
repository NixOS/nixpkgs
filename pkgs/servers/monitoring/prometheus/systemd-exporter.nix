{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "systemd_exporter";
  version = "0.4.0";

  vendorSha256 = "sha256-bYoB0r+d0j3esi/kK2a7/Duup9cf4M3WJjiBNs2+bj8=";

  src = fetchFromGitHub {
    owner = "povilasv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JDfRHczFnTP9sxA7polUE9qzJhSPIiAU58GBNDYkX4c=";
  };

  passthru.tests = { inherit (nixosTests.prometheus-exporters) systemd; };

  meta = with lib; {
    description = "Exporter for systemd unit metrics";
    homepage = "https://github.com/povilasv/systemd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ chkno ];
    platforms = platforms.unix;
  };
}
