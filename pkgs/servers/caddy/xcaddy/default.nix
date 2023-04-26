{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xcaddy";
  version = "0.3.3";

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HDyHvHa8yCz59AifHxQ0LAuC/xPXQInuUYURx7bL3oE=";
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
    maintainers = with maintainers; [ tjni indeednotjames ];
  };
}
