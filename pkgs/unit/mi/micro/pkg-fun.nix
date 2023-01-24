{ lib, buildGoModule, fetchFromGitHub, installShellFiles, callPackage }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3Rppi8UcAc4zdXOd81Y+sb5Psezx2TQsNw73WdPVMgE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  vendorSha256 = "sha256-/bWIn5joZOTOtuAbljOc0NgBfjrFkbFZih+cPNHnS9w=";

  ldflags = let t = "github.com/zyedidia/micro/v2/internal"; in [
    "-s"
    "-w"
    "-X ${t}/util.Version=${version}"
    "-X ${t}/util.CommitHash=${src.rev}"
  ];

  preBuild = ''
    go generate ./runtime
  '';

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dt $out/share/applications assets/packaging/micro.desktop
    install -Dm644 assets/micro-logo-mark.svg $out/share/icons/hicolor/scalable/apps/micro.svg
  '';

  passthru.tests.expect = callPackage ./test-with-expect.nix {};

  meta = with lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
