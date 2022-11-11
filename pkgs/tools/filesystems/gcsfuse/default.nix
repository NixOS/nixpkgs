{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gcsfuse";
  version = "0.41.8";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    sha256 = "sha256-9Y6phVYWI5xhqJf2LL9WbaG8vyfNcGUcnaHjKA4krjA=";
  };

  vendorSha256 = null;

  subPackages = [ "." "tools/mount_gcsfuse" ];

  ldflags = [ "-s" "-w" "-X main.gcsfuseVersion=${version}" ];

  preCheck =
    let skippedTests = [
      "Test_Main"
      "TestFlags"
    ]; in
    ''
      # Disable flaky tests
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

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
