{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gcsfuse";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    sha256 = "0dh01qvsjlzji2mwznykc2nghg4f1raylvgnp6sbxv9x1kpnwx71";
  };

  modSha256 = "0i86xs3lq2mj22yv7jmhmb34k7lz348bakqz020xpyccllkkszy4";

  patches = [
    ./go.mod.patch
    ./go.sum.patch
  ];

  meta = with lib;{
    description = "A user-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [];
  };
}
