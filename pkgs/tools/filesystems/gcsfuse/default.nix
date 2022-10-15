{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gcsfuse";
  version = "0.41.7";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    sha256 = "sha256-hqT1X78g1Mg7xWHrVTwN41P+wgkrjfYrX2vHmwxZoCQ=";
  };

  vendorSha256 = null;

  subPackages = [ "." "tools/mount_gcsfuse" ];

  ldflags = [ "-s" "-w" "-X main.gcsfuseVersion=${version}" ];

  postInstall = ''
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.gcsfuse
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.fuse.gcsfuse
  '';

  meta = with lib;{
    description = "A user-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
