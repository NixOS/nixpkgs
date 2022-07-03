{ lib, buildGoModule, fetchFromGitHub, pkg-config, libusb1 }:

buildGoModule rec {
  pname = "go-mtpfs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hanwen";
    repo = "go-mtpfs";
    rev = "v${version}";
    sha256 = "sha256-HVfB8/MImgZZLx4tcrlYOfQjpAdHMHshEaSsd+n758w=";
  };

  vendorSha256 = "sha256-OrAEvD2rF0Y0bvCD9TUv/E429lASsvC3uK3qNvbg734=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "A simple FUSE filesystem for mounting Android devices as a MTP device";
    homepage = "https://github.com/hanwen/go-mtpfs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
