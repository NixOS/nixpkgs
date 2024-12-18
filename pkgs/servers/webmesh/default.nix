{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "webmesh";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "webmeshproj";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S7kenBrnhM8V0TdbRe+CJP2XGHG/dZbfGVwdRurPeP8=";
  };

  vendorHash = "sha256-LBd5IrNFGkEhz+joDv6juL7WuoFyoqCXnmEHFB1K6Nc=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/node" "cmd/wmctl" ];

  ldflags = [
    "-w"
    "-s"
    "-X github.com/webmeshproj/webmesh/pkg/version.Version=${version}"
    "-X github.com/webmeshproj/webmesh/pkg/version.Commit=v${version}"
  ];

  postInstall = ''
    mv $out/bin/node $out/bin/webmesh-node
  '';

  meta = with lib; {
    description = "Simple, distributed, zero-configuration WireGuard mesh provider";
    homepage = "https://webmeshproj.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
