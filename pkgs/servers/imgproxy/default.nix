{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-wr4yOrzZT/4WtRze9Yp+M18jusxdddoDd4xs5P7d5oQ=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-7IpMgsATQ1SMuBOF9agHIN2Lx6OKxRr0Zk5SRFxHiQ4=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
