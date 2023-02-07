{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqldef";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HyM2HTdQgH+2vFe+1q02zmaD/A1M5h6Z56Wff9qxaHM=";
  };

  vendorSha256 = "sha256-T1Kdtpm90fy93mYWQz13k552wWGB96BOeN8NtTuuj0c=";

  # The test requires a running database
  doCheck = false;

  meta = with lib; {
    description = "Idempotent SQL schema management tool";
    license = with licenses; [ mit /* for everythnig except parser */  asl20 /* for parser */ ];
    homepage = "https://github.com/k0kubun/sqldef";
    maintainers = with maintainers; [ kgtkr ];
  };
}
