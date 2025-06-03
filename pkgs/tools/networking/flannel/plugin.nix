{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cni-plugin-flannel";
  version = "1.6.2-flannel1";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-mhDUpQf1HQLx4vn+Ju5jN5DYgkdsAs8CcmZbBqEITB4=";
  };

  vendorHash = "sha256-0LgdvXNejEAgJZ9ufN3HJ+hXjUtrL0iqaQg9SpeCThM=";

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

  meta = with lib; {
    description = "flannel CNI plugin";
    mainProgram = "flannel";
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbe ];
  };
}
