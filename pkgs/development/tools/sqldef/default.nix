{ lib, buildGoModule, fetchFromGitHub, libpg_query, xxHash, postgresql }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.16.9";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-Y4H8tPUHaRMMZaZt1VjkZT5JJgEIY/dhocNccvoHf1Y=";
  };

  proxyVendor = true;

  vendorHash = "sha256-Qn10+uTAo68OTQp592H/T7D99LNIvG76aG/ye+xx2sk=";

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
