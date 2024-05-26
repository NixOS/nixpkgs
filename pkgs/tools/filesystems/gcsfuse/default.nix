{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-1SKTwHvSCkkYhPY2yVTIRVsddW/Gt8Vke6W+a4VO6fc=";
  };

  vendorHash = "sha256-7IEF11gqou3Dk+CdU1HKPV7MyksldMmciQ74I9MEtuo=";

  subPackages = [ "." "tools/mount_gcsfuse" ];

  ldflags = [ "-s" "-w" "-X main.gcsfuseVersion=${version}" ];

  checkFlags =
    let
      skippedTests = [
        # Disable flaky tests
        "Test_Main"
        "TestFlags"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

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
