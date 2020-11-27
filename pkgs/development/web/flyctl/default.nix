{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.150";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "1wj3l32f9xpmqq91nzlxy8zgh1zkx4ckhc9r487agmv80bfjnzj2";
  };

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  vendorSha256 = "018vffgi85aqzb93hbld2f3lrc01jxb9aj5j5ss5c0a689g83gmq";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/superfly/flyctl/flyctl.Version=${version} -X github.com/superfly/flyctl/flyctl.Commit=${src.rev} -X github.com/superfly/flyctl/flyctl.BuildDate=1970-01-01T00:00:00+0000 -X github.com/superfly/flyctl/flyctl.Environment=production" ];

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}
