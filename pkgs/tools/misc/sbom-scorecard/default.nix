{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "sbom-scorecard";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "eBay";
    repo = "sbom-scorecard";
    rev = "${version}";
    hash = "sha256-XE+c1IhtC5dHdVTQbtSqQky2Drwgd5ADzH8DdtJhYfA=";
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

  vendorSha256 = "sha256-hHJJadD0q5obhdAQj24cFBsFujwWplRsshR4OXc8Dco=";

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;
  GO111MODULE = "on";
  GOWORK = "off";
  GOFLAGS = "-trimpath";

  subPackages = [ "./cmd/sbom-scorecard" ];

  ldflags = [
    "-s"
    "-w"
    "-buildid="
    "-X main.Version=v${version}"
    "-X main.TreeState=clean"
  ];

  doCheck = false;

 # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X main.Commit=$(cat COMMIT)"
    ldflags+=" -X main.CommitDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  meta = {
    homepage = "https://github.com/eBay/sbom-scorecard";
    changelog = "https://github.com/eBay/sbom-scorecard/releases/tag/${version}";
    description = "Generate a score for your sbom to understand if it will actually be useful.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy ];
  };
}
