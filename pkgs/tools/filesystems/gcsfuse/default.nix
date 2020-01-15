{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gcsfuse";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    sha256 = "11an7cxgg3x830mwlhyx50xkcv7zpa9aziz6gz1crwp8shr4hdik";
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
