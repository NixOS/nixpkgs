{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gortr";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W6+zCLPcORGcRJF0F6/LRPap4SNVn/oKGs21T4nSNO0=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "The RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
