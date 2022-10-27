{ lib, buildGoModule, fetchFromGitLab, fetchurl, bash }:

let
  version = "15.5.0";
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

  vendorSha256 = "sha256-IcsYH1V3b5IUY2JqOADJrc4lkng1GS7lndfHObRQbxU=";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
    sha256 = "sha256-WdrvVmuYyFAMwUDEANOjXiPoQ8rvXbcQz5mBlWUL54k=";
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
  '';

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
    maintainers = with maintainers; [ bachp zimbatm globin yayayayaka ];
  };
}
