{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "lndmon";
  version = "unstable-2020-12-04";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndmon";
    sha256 = "0q72jbkhw1vpwxd0r80l1v4ab71sakc315plfqbijy7al9ywq5nl";
    rev = "f07d574320dd1a6a428fecd47f3a5bb46a0fc4d1";
  };

  vendorSha256 = "06if387b9m02ciqgcissih1x06l33djp87vgspwzz589f77vczk8";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) lnd; };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for lnd (Lightning Network Daemon)";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
