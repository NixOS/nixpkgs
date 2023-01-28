{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "syft";
  version = "0.66.2";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CIFK4XIYpRK9CJOwQUV6kRGU++iWJCdMBR7v6xh0iaY=";
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
  # hash mismatch with darwin
  proxyVendor = true;
  vendorHash = "sha256-ttvfzlSFgh0xQ0W/ftLeSrJNOzg7Iq1qdLgflGy7N8Q=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/syft" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anchore/syft/internal/version.version=${version}"
    "-X github.com/anchore/syft/internal/version.gitDescription=v${version}"
    "-X github.com/anchore/syft/internal/version.gitTreeState=clean"
  ];

  preBuild = ''
    ldflags+=" -X github.com/anchore/syft/internal/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X github.com/anchore/syft/internal/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export SYFT_CHECK_FOR_APP_UPDATE=false
    $out/bin/syft --help
    $out/bin/syft version | grep "${version}"

    runHook postInstallCheck
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
