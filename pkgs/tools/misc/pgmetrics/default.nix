{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1acdak3m9782hr5bn26ck3dnnv1jxwz5yrkyv8kivavjww88m9h2";
  };

  vendorSha256 = "16x33fmh4q993rw0jr65337yimska4fwgyyw3kmq84q0x28a3zg5";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
