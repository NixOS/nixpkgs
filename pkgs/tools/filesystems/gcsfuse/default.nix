{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-gayzCUL6xM56sy8a5ljwN0X0kjW56YLJtLwFOpxBsG4=";
  };

  vendorHash = "sha256-3b0qk/EfVfObG8Rqj2N5DypoOozCY4E2LQiGQmOMTOY=";

  subPackages = [ "." "tools/mount_gcsfuse" ];

  ldflags = [ "-s" "-w" "-X main.gcsfuseVersion=${version}" ];

  preCheck =
    let
      skippedTests = [
        "Test_Main"
        "TestFlags"
      ];
    in
    ''
      # Disable flaky tests
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  postInstall = ''
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.gcsfuse
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.fuse.gcsfuse
  '';

  meta = with lib; {
    description = "A user-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    changelog = "https://github.com/GoogleCloudPlatform/gcsfuse/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
