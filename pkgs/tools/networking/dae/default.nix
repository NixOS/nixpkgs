{ lib
, clang
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:
buildGoModule rec {
  pname = "dae";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-DxGKfxu13F7+5zV/31GP9gkbGHrz5RdRe84J3DQ0iUs=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-UQRM3/JSsPDAGqYZ43bVYVvSLvqqZ/BJE6hwx5wzfcQ=";

  proxyVendor = true;

  nativeBuildInputs = [ clang installShellFiles ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/daeuniverse/dae/cmd.Version=${version}"
    "-X github.com/daeuniverse/dae/common/consts.MaxMatchSetLen_=64"
  ];

  preBuild = ''
    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
    NOSTRIP=y \
    ebpf
  '';

  # network required
  doCheck = false;

  postInstall = ''
    install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
    substituteInPlace $out/lib/systemd/system/dae.service \
      --replace /usr/bin/dae $out/bin/dae
    installShellCompletion install/shell-completion/dae.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "A Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ oluceps pokon548 ];
    platforms = platforms.linux;
    mainProgram = "dae";
  };
}
