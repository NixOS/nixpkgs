{ lib, buildGoModule, fetchFromGitHub, pkg-config, pcsclite }:

buildGoModule rec {
  pname = "piv-agent";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "smlx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FbA2mRNnIluUXONn3q2OUbjyh3+X50eyOglDTR39kFE=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/SHORT_COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorSha256 = "sha256-LQIQ7OZJXIVWPoxfLzMV0pJtg/UzUNOLz8kd0c6o5RY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcsclite ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # ldflags based on metadata from git and go
  preBuild = ''
    ldflags+=" -X main.shortCommit=$(cat SHORT_COMMIT)"
    ldflags+=" -X \"main.goVersion=$(go version)\""
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/piv-agent --help
    $out/bin/piv-agent version | grep "${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://smlx.github.io/piv-agent/";
    changelog = "https://github.com/smlx/piv-agent/releases";
    description = "SSH and GPG agent you can use with your PIV hardware security device (e.g. a Yubikey)";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
