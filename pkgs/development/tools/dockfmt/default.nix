{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dockfmt";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "jessfraz";
    repo = "dockfmt";
    rev = "v${version}";
    sha256 = "0m56ydmf7zbcsa5yym7j5fgr75v677h9s40zyzwrqccyq01myp06";
  };

  vendorSha256 = null;

  ldflags = [
    "-w"
    "-s"
    "-X github.com/jessfraz/dockfmt/version.VERSION=${version}"
  ];

  meta = with lib; {
    description = "Dockerfile format";
    homepage = "https://github.com/jessfraz/dockfmt";
    license = [ licenses.mit ];
    maintainers = [ maintainers.cpcloud ];
  };
}
