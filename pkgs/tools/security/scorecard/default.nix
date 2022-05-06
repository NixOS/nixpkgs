{ lib, buildGoModule, fetchFromGitHub, fetchgit, installShellFiles }:

buildGoModule rec {
  pname = "scorecard";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QOWQhuEEnwtHmQwl5WCCHcKMjwhgxn9xerR0Bxi3660=";
    # populate values otherwise taken care of by goreleaser,
    # unfortunately these require us to use git. By doing
    # this in postFetch we can delete .git afterwards and
    # maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"

      commit="$(git rev-parse HEAD)"
      source_date_epoch=$(git log --date=iso8601-strict -1 --pretty=%ct)

      substituteInPlace "$out/pkg/scorecard_version.go" \
        --replace 'gitCommit = "unknown"' "gitCommit = \"$commit\"" \
        --replace 'buildDate = "unknown"' "buildDate = \"$source_date_epoch\""

      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-AFadBzkRj0D1MXLHzexvomJ0cqirhW82tnNRGx/gChI=";

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ossf/scorecard/v${lib.versions.major version}/pkg.gitVersion=v${version}"
    "-X github.com/ossf/scorecard/v${lib.versions.major version}/pkg.gitTreeState=clean"
  ];

  preCheck = ''
    # Feed in all but the e2e tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    getGoDirs() {
      go list ./... | grep -v e2e
    }
    # Ensure other e2e tests that have escaped the e2e dir dont run
    export SKIP_GINKGO=1
  '';

  postInstall = ''
    installShellCompletion --cmd scorecard \
      --bash <($out/bin/scorecard completion bash) \
      --fish <($out/bin/scorecard completion fish) \
      --zsh <($out/bin/scorecard completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/scorecard --help
    $out/bin/scorecard version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/ossf/scorecard";
    changelog = "https://github.com/ossf/scorecard/releases/tag/v${version}";
    description = "Security health metrics for Open Source";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
