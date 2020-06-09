{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "03c4v24ql9p38m0hmgq5ya9cnvhmdhv2zjxxrxpb2338cxajs4mh";
  };

  vendorSha256 = "16x33fmh4q993rw0jr65337yimska4fwgyyw3kmq84q0x28a3zg5";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}