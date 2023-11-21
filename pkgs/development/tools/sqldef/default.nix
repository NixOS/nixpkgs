{ lib, buildGoModule, fetchFromGitHub, libpg_query, xxHash, postgresql }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.16.10";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-NwSQLpqgOuVBH+EYjSch3h0BMJZPK3/FcKO4iUnNt+E=";
  };

  proxyVendor = true;

  vendorHash = "sha256-2MwibiWT9rrbNVva61wR1OPrG+fZkxTDznC2pdm3CKE=";

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
