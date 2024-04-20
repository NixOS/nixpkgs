{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.17.6";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-VgPc78xhafRlEUfNMKiYDyWqZVtYDkqwVDQ3BG9r70w=";
  };

  proxyVendor = true;

  vendorHash = "sha256-YmjQj116egYhcpJ9Vps1d30bfCY6pAu/mA9MEzXVJb8=";

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
