{ lib, buildGoModule, fetchFromGitHub, pkg-config, libusb1, updateGolangSysHook }:

buildGoModule rec {
  pname = "go-mtpfs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hanwen";
    repo = "go-mtpfs";
    rev = "v${version}";
    sha256 = "sha256-HVfB8/MImgZZLx4tcrlYOfQjpAdHMHshEaSsd+n758w=";
  };

  vendorSha256 = "sha256-ESh3k1rYLz49VVepoIroMTSYcZjzZ38Diby4oMUqzL0=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config updateGolangSysHook ];
  buildInputs = [ libusb1 ];

  preCheck = ''
    # Only run tests under mtp/encoding_test.go
    # Other tests require an Android deviced attached over USB.
    buildFlagsArray+=("-run" "Test(Encode|Decode|Variant).*")
  '';

  meta = with lib; {
    description = "A simple FUSE filesystem for mounting Android devices as a MTP device";
    homepage = "https://github.com/hanwen/go-mtpfs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
