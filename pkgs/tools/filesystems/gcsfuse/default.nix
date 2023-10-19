{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-fMKFQheFlSwz4ik1tgLheZGkS55LHq3nncOmvgY/TqM=";
  };

  vendorHash = "sha256-bgZgYbQN6Dg4uHp29tazJ9un9fR1o9mYp8R8ZHtAs9Q=";

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
