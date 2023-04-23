{ lib
, clang
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "dae";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J/LKVmWda88kaLY1w0elEoksrWswDvuhb6RTZvl6uH0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-euTgB660px8J/3D3n+jzyetzzs6uD6yrXGvIgqzQcR0=";

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
