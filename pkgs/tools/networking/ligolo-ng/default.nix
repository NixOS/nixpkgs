{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    sha256 = "sha256-Ipfp+Ke4iSJmvUtfNUt/XSPTSDSdeMs+Ss8acZHUYrE=";
  };

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  vendorSha256 = "sha256-axRCThmFavR+GTRWSgdAr2mbrp07hsFea0rKLQNIhgU=";

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
