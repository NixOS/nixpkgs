{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "grype";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hEWs1o4Y3fm6dbkpClKxvR4qt5egE6Yt70V9sd3GK3I=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorSha256 = "sha256-BB7E6wb6A97AATxFHENLo+Q+oVYOnYRzC/15bfomgR4=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anchore/grype/internal/version.version=${version}"
    "-X github.com/anchore/grype/internal/version.gitDescription=v${version}"
    "-X github.com/anchore/grype/internal/version.gitTreeState=clean"
  ];

  preBuild = ''
    # grype version also displays the version of the syft library used
    # we need to grab it from the go.sum and add an ldflag for it
    SYFT_VERSION="$(grep "github.com/anchore/syft" go.sum -m 1 | awk '{print $2}')"
    ldflags+=" -X github.com/anchore/grype/internal/version.syftVersion=$SYFT_VERSION"
    ldflags+=" -X github.com/anchore/grype/internal/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X github.com/anchore/grype/internal/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
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
    # Need updated macOS SDK
    # https://github.com/NixOS/nixpkgs/issues/101229
    broken = (stdenv.isDarwin && stdenv.isx86_64);
  };
}
