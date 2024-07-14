{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-FxBVNJVcVdAAvkIWzFmWiVdrVEQ4eQGGo8tmrlcH+6k=";
  };

  vendorHash = "sha256-9eUUjcRQ/H3iPO2F+KE0nd5+b8slc6xacXSZt3jytgU=";

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
    description = "User-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    changelog = "https://github.com/GoogleCloudPlatform/gcsfuse/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
