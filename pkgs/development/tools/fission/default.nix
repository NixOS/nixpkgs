{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${version}";
    hash = "sha256-zI8OBjmV7pnFe18sChRNdC2RQGfCif/5IG9sn/yHE94=";
  };

  vendorHash = "sha256-W5fPa02rpWhGwYJzRkn8umqdMHG72Ym8+S0f+Id/mcM=";

  ldflags = [ "-s" "-w" "-X info.Version=${version}" ];

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "Cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
