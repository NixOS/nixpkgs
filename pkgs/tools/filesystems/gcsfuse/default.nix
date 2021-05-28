{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gcsfuse";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    sha256 = "1ai1dgf07g2c08rp87kygrl67hyj7x793093wmnwaxfpylx5flv0";
  };

  goPackagePath = "github.com/googlecloudplatform/gcsfuse";

  subPackages = [ "." "tools/mount_gcsfuse" ];

  postInstall = ''
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.gcsfuse
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.fuse.gcsfuse
  '';

  buildFlagsArray = [ "-ldflags=-s -w -X main.gcsfuseVersion=${version}" ];

  meta = with lib;{
    description = "A user-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [];
  };
}
