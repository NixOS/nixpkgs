{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0mhdw985gs9gh44iz78a588nnnapirpnd7s0zh35jyripx8pgw47";
  };

  vendorSha256 = "16x33fmh4q993rw0jr65337yimska4fwgyyw3kmq84q0x28a3zg5";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
