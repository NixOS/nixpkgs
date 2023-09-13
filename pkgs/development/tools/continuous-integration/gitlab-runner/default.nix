{ lib, buildGoModule, fetchFromGitLab, fetchurl, bash }:

let
<<<<<<< HEAD
  version = "16.3.0";
=======
  version = "15.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildGoModule rec {
  inherit version;
  pname = "gitlab-runner";

  commonPackagePath = "gitlab.com/gitlab-org/gitlab-runner/common";
  ldflags = [
    "-X ${commonPackagePath}.NAME=gitlab-runner"
    "-X ${commonPackagePath}.VERSION=${version}"
    "-X ${commonPackagePath}.REVISION=v${version}"
  ];

  # For patchShebangs
  buildInputs = [ bash ];

<<<<<<< HEAD
  vendorHash = "sha256-tMhzq9ygUmNi9+mlI9Gvr2nDyG9HQbs8PVusSgadZIE=";
=======
  vendorHash = "sha256-4eSfNo5S/eottEN4AptGJq6pBDHkNud0Nj5GrqutADM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-YAnHOIpUN1OuNefjCIccZOLwPNMxVBuCRQgX0Tb5bos=";
=======
    sha256 = "sha256-S4KdEepNWv8J5+r/GT8+8kAKU5fq2iwQU+qyoCY1s0o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./fix-shell-path.patch
    ./remove-bash-test.patch
  ];

  prePatch = ''
    # Remove some tests that can't work during a nix build

    # Requires to run in a git repo
    sed -i "s/func TestCacheArchiverAddingUntrackedFiles/func OFF_TestCacheArchiverAddingUntrackedFiles/" commands/helpers/file_archiver_test.go
    sed -i "s/func TestCacheArchiverAddingUntrackedUnicodeFiles/func OFF_TestCacheArchiverAddingUntrackedUnicodeFiles/" commands/helpers/file_archiver_test.go

    # No writable developer environment
    rm common/build_test.go
    rm executors/custom/custom_test.go

    # No docker during build
    rm executors/docker/terminal_test.go
    rm executors/docker/docker_test.go
    rm helpers/docker/auth/auth_test.go
    rm executors/docker/services_test.go
  '';

<<<<<<< HEAD
  excludedPackages = [
    # CI helper script for pushing images to Docker and ECR registries
    # https://gitlab.com/gitlab-org/gitlab-runner/-/merge_requests/4139
    "./scripts/sync-docker-images"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    install packaging/root/usr/share/gitlab-runner/clear-docker-cache $out/bin
  '';

  preCheck = ''
    # Make the tests pass outside of GitLab CI
    export CI=0
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = "https://about.gitlab.com/gitlab-ci/";
    platforms = platforms.unix ++ platforms.darwin;
<<<<<<< HEAD
    maintainers = with maintainers; [ bachp zimbatm globin ] ++ teams.gitlab.members;
=======
    maintainers = with maintainers; [ bachp zimbatm globin yayayayaka ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
