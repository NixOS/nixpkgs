{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cni-plugin-flannel";
  version = "1.9.0-flannel1";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-skYbIU1uqfEiXDEG5N0QVbMH/8X9MIJRH7XoXq5zA7w=";
  };

  vendorHash = "sha256-hn4NT/fXu7bremIpYPSva/Od97LiVuHE7+8jgpLMaRs=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.Program=flannel"
  ];

  postInstall = ''
    mv $out/bin/cni-plugin $out/bin/flannel
  '';

  doCheck = false;
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/flannel 2>&1 | fgrep -q $version
    runHook postInstallCheck
  '';

  meta = {
    description = "Network fabric for containers designed to work in conjunction with flannel";
    mainProgram = "flannel";
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbe ];
  };
}
