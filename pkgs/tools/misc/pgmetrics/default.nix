{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fwc4qc17fqmzx08kiyfx5iwgzr14dxk9i8zjd9bq5gk281v0ybd";
  };

  vendorSha256 = "18da45axjl8l3qb6f3w5v2c7clz4bjhdz2bck20j729k7693hpsl";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
