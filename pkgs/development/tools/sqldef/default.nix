{ lib, buildGoModule, fetchFromGitHub, libpg_query, xxHash, postgresql }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-HQ6WyeKYRd+pY/P2Bsu7W2eMjgpjUhbwEFE7bADrxDY=";
  };

  proxyVendor = true;

  vendorHash = "sha256-YdZo2XN+425s0K/3COqQx3g1Bpus4uWiwnzrYJ8qdOM=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # The test requires a running database
  doCheck = false;

  meta = with lib; {
    description = "Idempotent SQL schema management tool";
    license = with licenses; [ mit /* for everything except parser */  asl20 /* for parser */ ];
    homepage = "https://github.com/k0kubun/sqldef";
    changelog = "https://github.com/k0kubun/sqldef/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ kgtkr ];
  };
}
