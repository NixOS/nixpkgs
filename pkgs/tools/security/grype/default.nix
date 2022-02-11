{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "grype";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jn28IusHgHHFFrvqZLIvbqCFMhMQ5K/gqC4hVQLffY0=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      commit="$(git rev-parse HEAD)"
      source_date_epoch=$(git log --date=format:'%Y-%m-%dT%H:%M:%SZ' -1 --pretty=%ad)
      substituteInPlace "$out/internal/version/build.go" \
        --replace 'gitCommit = valueNotProvided' "gitCommit = \"$commit\"" \
        --replace 'buildDate = valueNotProvided' "buildDate = \"$source_date_epoch\""
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-05/xFjgiqbXy7Y2LTGHcXtvusGgfZ/TwLQHaO8rIjvc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anchore/grype/internal/version.version=${version}"
    "-X github.com/anchore/grype/internal/version.gitTreeState=clean"
  ];

  preBuild = ''
    # grype version also displays the version of the syft library used
    # we need to grab it from the go.sum and add an ldflag for it
    SYFTVERSION="$(grep "github.com/anchore/syft" go.sum -m 1 | awk '{print $2}')"
    ldflags+=" -X github.com/anchore/grype/internal/version.syftVersion=$SYFTVERSION"
  '';

  # Tests require a running Docker instance
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd grype \
      --bash <($out/bin/grype completion bash) \
      --fish <($out/bin/grype completion fish) \
      --zsh <($out/bin/grype completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/anchore/grype";
    changelog = "https://github.com/anchore/grype/releases/tag/v${version}";
    description = "Vulnerability scanner for container images and filesystems";
    longDescription = ''
      As a vulnerability scanner grype is able to scan the contents of a
      container image or filesystem to find known vulnerabilities.
    '';
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab jk ];
  };
}
