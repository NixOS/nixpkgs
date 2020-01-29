{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gcsfuse";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    sha256 = "11an7cxgg3x830mwlhyx50xkcv7zpa9aziz6gz1crwp8shr4hdik";
  };

  goPackagePath = "github.com/googlecloudplatform/gcsfuse";

  subPackages = [ "." "tools/mount_gcsfuse" ];

  postInstall = ''
    ln -s $bin/bin/mount_gcsfuse $bin/bin/mount.gcsfuse
    ln -s $bin/bin/mount_gcsfuse $bin/bin/mount.fuse.gcsfuse
  '';

  meta = with lib;{
    description = "A user-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [];
  };
}
