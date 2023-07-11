{ lib
, clang
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "dae";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J2FFD6/+Of1UcBmgzlAfmX5QvEgJY4P1EttlNaqW4P0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-2KKlbhJtoHUa02juXuS1QgvDD5LA5Tg/f0hNFscLJIQ=";

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/daeuniverse/dae/cmd.Version=${version}"
    "-X github.com/daeuniverse/dae/common/consts.MaxMatchSetLen_=64"
  ];

  preBuild = ''
    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector" \
    NOSTRIP=y \
    ebpf
  '';

  # network required
  doCheck = false;

  meta = with lib; {
    description = "A Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
