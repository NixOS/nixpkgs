{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.17.8";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-60CN+Z5YZemYwn7eN0VZ/S8kAmQv6DBA1tCAhDLDKe0=";
  };

  proxyVendor = true;

  vendorHash = "sha256-I1kyXotFYvnL8/FryjKJWGOYSTeXrXNB1+TNgR7q3qo=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # The test requires a running database
  doCheck = false;

  meta = with lib; {
    description = "Idempotent SQL schema management tool";
    license = with licenses; [ mit /* for everything except parser */ asl20 /* for parser */ ];
    homepage = "https://github.com/k0kubun/sqldef";
    changelog = "https://github.com/k0kubun/sqldef/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ kgtkr ];
  };
}
