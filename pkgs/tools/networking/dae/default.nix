{
  lib,
  clang,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "dae";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-hvAuWCacaWxXwxx5ktj57hnWt8fcnwD6rUuRj1+ZtFA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-4U6zIxK8K+MGxRboTtsKntDMp8/cQWPqXQ3l03AEtBs=";

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

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
  '';

  meta = with lib; {
    description = "A Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      oluceps
      pokon548
    ];
    platforms = platforms.linux;
    mainProgram = "dae";
  };
}
