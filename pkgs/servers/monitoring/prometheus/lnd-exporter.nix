{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "lndmon";
  version = "unstable-2021-03-26";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndmon";
    sha256 = "14lmmjq61p8yhc86swigs43risqi31vlmz7ri8j0n0fyp8lm2kxs";
    rev = "3aa925aa4f633a6c4d132601922e78f173ae8ac1";
  };

  vendorSha256 = "06if387b9m02ciqgcissih1x06l33djp87vgspwzz589f77vczk8";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) lnd; };

  meta = with lib; {
    homepage = "https://github.com/lightninglabs/lndmon";
    description = "Prometheus exporter for lnd (Lightning Network Daemon)";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
