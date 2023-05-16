{ lib
, clang
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "dae";
<<<<<<< HEAD
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-WiJqhXYehuUCLEuVbsQkmTntuH1srtePtZgYBSTbxiw=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-fb4PEMhV8+5zaRJyl+nYi2BHcOUDUVAwxce2xaRt5JA=";
=======
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J/LKVmWda88kaLY1w0elEoksrWswDvuhb6RTZvl6uH0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-euTgB660px8J/3D3n+jzyetzzs6uD6yrXGvIgqzQcR0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/daeuniverse/dae/cmd.Version=${version}"
    "-X github.com/daeuniverse/dae/common/consts.MaxMatchSetLen_=64"
  ];

  preBuild = ''
<<<<<<< HEAD
    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
=======
    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    NOSTRIP=y \
    ebpf
  '';

  # network required
  doCheck = false;

<<<<<<< HEAD
  postInstall = ''
    install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
    substituteInPlace $out/lib/systemd/system/dae.service \
      --replace /usr/bin/dae $out/bin/dae
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
<<<<<<< HEAD
    maintainers = with maintainers; [ oluceps pokon548 ];
    platforms = platforms.linux;
    mainProgram = "dae";
=======
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
