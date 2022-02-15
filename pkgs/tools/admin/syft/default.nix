{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "syft";
  version = "0.37.10";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j3/WE13djrgI7S6YISg9kPIkV0IR0C65QU8zj0z0MVg=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      commit="$(git rev-parse HEAD)"
      source_date_epoch="$(git log --date=format:'%Y-%m-%dT%H:%M:%SZ' -1 --pretty=%ad)"
      substituteInPlace "$out/internal/version/build.go" \
        --replace 'gitCommit = valueNotProvided' "gitCommit = \"$commit\"" \
        --replace 'buildDate = valueNotProvided' "buildDate = \"$source_date_epoch\""
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-gIcPxSzWzldR9UX4iB2fkwc0BfATT1B+Nge+sGefmj8=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anchore/syft/internal/version.version=${version}"
    "-X github.com/anchore/syft/internal/version.gitTreeState=clean"
    "-X github.com/anchore/syft/internal/version.gitDescription=v${version}"
  ];

  # tests require a running docker instance
  doCheck = false;

  postInstall = ''
    # avoid update checks when generating completions
    export SYFT_CHECK_FOR_APP_UPDATE=false

    installShellCompletion --cmd syft \
      --bash <($out/bin/syft completion bash) \
      --fish <($out/bin/syft completion fish) \
      --zsh <($out/bin/syft completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/anchore/syft";
    changelog = "https://github.com/anchore/syft/releases/tag/v${version}";
    description = "CLI tool and library for generating a Software Bill of Materials from container images and filesystems";
    longDescription = ''
      A CLI tool and Go library for generating a Software Bill of Materials
      (SBOM) from container images and filesystems. Exceptional for
      vulnerability detection when used with a scanner tool like Grype.
    '';
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jk ];
  };
}
