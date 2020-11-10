{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc38";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    sha256 = "0a9xwv8c4ivpyh1hm3nzssnqpr4c6br0qb27mz3sy6fp2p46c0ms";
  };

  vendorSha256 = "03hicp3h4jrq7ihirpcmgkk5siiny3w2wnwhibaf36j9xllmf57f";

  doCheck = false;

  subPackages = [ "cmd/mtail" ];

  preBuild = ''
    go generate -x ./internal/vm/
  '';

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
