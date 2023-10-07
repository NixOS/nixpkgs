{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xcaddy";
  version = "0.3.5";

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XxklyOaKFPyWFabodNCcV1NnaPWS0AQ2Sj89ZZ5hJbk=";
  };

  patches = [
    ./inject_version_info.diff
    ./use_tmpdir_on_darwin.diff
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/xcaddy/cmd.customVersion=v${version}"
  ];

  vendorHash = "sha256-RpbnoXyTrqGOI7DpgkO+J47P17T4QCVvM1CfS6kRO9Y=";

  meta = with lib; {
    homepage = "https://github.com/caddyserver/xcaddy";
    description = "Build Caddy with plugins";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni emilylange ];
  };
}
