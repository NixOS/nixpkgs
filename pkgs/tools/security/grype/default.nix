{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, openssl
}:

buildGoModule rec {
  pname = "grype";
  version = "0.65.1";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hmjg1W1E1pdrHxPA7qbEJP0R1mEiV0P54+y+RXxKH4c=";
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

  proxyVendor = true;

  vendorHash = "sha256-VxsXhNOFj7Iwq7Sa2J8ADcfLt9Bz+D0RHwEGawveryU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    openssl
  ];

  subPackages = [ "cmd/grype" ];

  excludedPackages = "test/integration";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/anchore/grype/internal/version.version=${version}"
    "-X=github.com/anchore/grype/internal/version.gitDescription=v${version}"
    "-X=github.com/anchore/grype/internal/version.gitTreeState=clean"
  ];

  preBuild = ''
    # grype version also displays the version of the syft library used
    # we need to grab it from the go.sum and add an ldflag for it
    SYFT_VERSION="$(grep "github.com/anchore/syft" go.sum -m 1 | awk '{print $2}')"
    ldflags+=" -X github.com/anchore/grype/internal/version.syftVersion=$SYFT_VERSION"
    ldflags+=" -X github.com/anchore/grype/internal/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X github.com/anchore/grype/internal/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  preCheck = ''
    # test all dirs (except excluded)
    unset subPackages
    # test goldenfiles expect no version
    unset ldflags

    # patch utility script
    patchShebangs grype/db/test-fixtures/tls/generate-x509-cert-pair.sh

    # remove tests that depend on docker
    substituteInPlace test/cli/cmd_test.go \
      --replace "TestCmd" "SkipCmd"
    substituteInPlace grype/pkg/provider_test.go \
      --replace "TestSyftLocationExcludes" "SkipSyftLocationExcludes"
    # remove tests that depend on git
    substituteInPlace test/cli/db_validations_test.go \
      --replace "TestDBValidations" "SkipDBValidations"
    substituteInPlace test/cli/registry_auth_test.go \
      --replace "TestRegistryAuth" "SkipRegistryAuth"
    substituteInPlace test/cli/sbom_input_test.go \
      --replace "TestSBOMInput_FromStdin" "SkipSBOMInput_FromStdin" \
      --replace "TestSBOMInput_AsArgument" "SkipSBOMInput_AsArgument"
    substituteInPlace test/cli/subprocess_test.go \
      --replace "TestSubprocessStdin" "SkipSubprocessStdin"

    # segfault
    rm grype/db/v5/namespace/cpe/namespace_test.go
  '';

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
