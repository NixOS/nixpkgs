{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cni-plugin-flannel";
  version = "1.4.0-flannel1";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-XTr5rJVrr5o5px5ho1qObZroTn1MJvL7EfiSgJuH7WU=";
  };

  vendorHash = "sha256-H6gmXcGrpW6jIQf10OslEQe4XOe/UQk+AV7jKSioYos=";

  ldflags = [
    "-s" "-w"
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
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbe ];
  };
}
