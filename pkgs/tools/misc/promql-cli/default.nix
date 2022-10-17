{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promql-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nalbury";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uuoUvEBnLxopdt6u4vX6pYnuyOATwJFJo9ozQ9jhSyo=";
  };

  vendorHash = "sha256-OLkOyeLyBnNmijNYFrXIZ4nbOvV/65KIKjOFOVS9Yiw=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv -v $out/bin/promql-cli $out/bin/promql
  '';

  meta = with lib; {
    description = "Command-line tool to query a Prometheus server with PromQL and visualize the output";
    homepage = "https://github.com/nalbury/promql-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
  };
}
