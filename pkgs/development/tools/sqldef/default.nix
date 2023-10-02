{ lib, buildGoModule, fetchFromGitHub, libpg_query, xxHash, postgresql }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.16.7";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-y28dn/LhqQxbszKwOjpiU93oP1tq/H0NL9vonhERLzw=";
  };

  proxyVendor = true;

  vendorHash = "sha256-ugLjaKCVgVl2jhH/blQ44y/c8hxQpbdlxUC4u+FgMGM=";

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
