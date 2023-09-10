{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gortr";
  version = "0.14.8";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3aZf5HINoFIJrN+196kk1lt2S+fN9DlQakwGnkMU5U8=";
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
