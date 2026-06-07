{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  testers,
  testWithWine ? true,
  wine64,
}:

buildGo125Module (finalAttrs: {
  pname = "npiperelay";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "albertony";
    repo = "npiperelay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kH2QXhzEfkR4EBHTBsTFxresRtvDpPVRf4ad+jRyAHg=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/COMMIT
      # in format of 0000-00-00T00:00:00Z (RFC3339)
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = null;

  # INFO: no explicit ldflags are set in the https://github.com/albertony/npiperelay/blob/v1.11.2/.goreleaser.yml
  # using default https://goreleaser.com/resources/cookbooks/using-main.version/
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
    # "-X main.commit=${finalAttrs.src.rev}"
    # "-X main.date=1970-01-01T00:00:00Z"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;
  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command =
      (if (testWithWine && stdenv.hostPlatform.isLinux) then "${lib.getExe wine64} " else "")
      + "${finalAttrs.meta.mainProgram}";
    version = "${finalAttrs.pname} ${finalAttrs.src.tag}";
  };

  meta = {
    description = "Access Windows named pipes from WSL";
    homepage = "https://github.com/albertony/npiperelay";
    changelog = "https://github.com/albertony/npiperelay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shlevy ];
    # INFO: use pkgs.pkgsCross.mingwW64.windows.npiperelay in WSL
    # Linux is added here to allow building and running npiperelay.exe from WSL,
    # but it is not the primary target platform
    platforms = lib.platforms.windows ++ lib.platforms.linux;
    mainProgram = "${finalAttrs.pname}.exe";
  };
})
