{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "refs/tags/v${version}";
    hash = "sha256-pFk/9AFtnMBNi5hdVWDzfxCTFe9wSkFydHciTpMRxQw=";
  };

  vendorHash = "sha256-QEGF12yJ+CQjIHx6kOwsykVhelp5npnglk7mIbOeIpI=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A tunneling/pivoting tool that uses a TUN interface";
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    changelog = "https://github.com/nicocha30/ligolo-ng/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
