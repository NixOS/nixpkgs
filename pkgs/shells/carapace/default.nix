{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "carapace";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aI69LQuyXUGqxjcUIH3J8AG7cgn/onBg0mZc+zz+YrA=";
  };

  vendorHash = "sha256-AwR+Oh1Rlg1z/pYdc9VDvp/FLH1ZiPsP/q4lks3VqqE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    GOOS= GOARCH= go generate ./...
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://carapace.sh/";
    maintainers = with maintainers; [ mimame ];
    license = licenses.mit;
    mainProgram = "carapace";
  };
})
