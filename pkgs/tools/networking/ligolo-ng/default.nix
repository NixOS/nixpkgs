{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    hash = "sha256-T+SBGAE+hzHzrYLTm6t7NGh78B1/84TMiT1odGSPtKo=";
  };

  vendorHash = "sha256-QEGF12yJ+CQjIHx6kOwsykVhelp5npnglk7mIbOeIpI=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
