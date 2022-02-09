{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skeema";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "skeema";
    repo = "skeema";
    rev = "v${version}";
    sha256 = "1a75vixrpidim641809nj931r73zvbj2rsls7d80z7w87maav51m";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "Declarative pure-SQL schema management for MySQL and MariaDB";
    homepage = "https://www.skeema.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ humancalico ];
  };
}
