{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fulcio";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jcmjfNGruDhQPhVn5R2hdUr+d42qQnIVj8+CCX5HMMM=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+'%Y-%m-%dT%H:%M:%SZ'" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-WQ0MuNEJWCxKTjkyqA66bGPoMrS/7W/YTiGU3yd+Ge8=";

  # install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [ "federation" "test/prometheus" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sigstore/fulcio/cmd/app.gitVersion=v${version}"
    "-X github.com/sigstore/fulcio/cmd/app.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/sigstore/fulcio/cmd/app.gitCommit=$(cat COMMIT)"
    ldflags+=" -X github.com/sigstore/fulcio/cmd/app.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  preCheck = ''
    # remove test that requires networking
    rm pkg/config/config_test.go
  '';

  postInstall = ''
    installShellCompletion --cmd fulcio \
      --bash <($out/bin/fulcio completion bash) \
      --fish <($out/bin/fulcio completion fish) \
      --zsh <($out/bin/fulcio completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/fulcio --help
    $out/bin/fulcio version | grep "v${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/fulcio";
    changelog = "https://github.com/sigstore/fulcio/releases/tag/v${version}";
    description = "A Root-CA for code signing certs - issuing certificates based on an OIDC email address";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
