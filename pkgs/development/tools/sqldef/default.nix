{ lib, buildGoModule, fetchFromGitHub, libpg_query, xxHash, postgresql }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.16.15";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "sqldef";
    rev = "v${version}";
    hash = "sha256-srwCSALP+xtccMnIOpsErn4hk83grXyOMEA2Hwsvjv0=";
  };

  proxyVendor = true;

  vendorHash = "sha256-VM50tJxChGU1lGol4HUKB5Zp0c2F8D9+NhrW6XK7i+g=";

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
