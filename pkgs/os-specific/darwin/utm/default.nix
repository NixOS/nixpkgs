{ lib
, undmg
, makeWrapper
, fetchurl
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "utm";
  version = "4.5.4";

  src = fetchurl {
    url = "https://github.com/utmapp/UTM/releases/download/v${version}/UTM.dmg";
    hash = "sha256-GzwokK/q8S38lbOVhGgNaqbDAAryHJ9eBAAWGpuOQOE=";
  };

  nativeBuildInputs = [ undmg makeWrapper ];

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    mkdir -p $out/bin
    for bin in $out/Applications/UTM.app/Contents/MacOS/*; do
      # Symlinking `UTM` doesn't work; seems to look for files in the wrong
      # place
      makeWrapper $bin "$out/bin/$(basename $bin)"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Full featured system emulator and virtual machine host for iOS and macOS";
    longDescription = ''
      UTM is a full featured system emulator and virtual machine host for iOS
      and macOS. It is based off of QEMU. In short, it allows you to run
      Windows, Linux, and more on your Mac, iPhone, and iPad.

      Features:
        - Full system emulation (MMU, devices, etc) using QEMU
        - 30+ processors supported including x86_64, ARM64, and RISC-V
        - VGA graphics mode using SPICE and QXL
        - Text terminal mode
        - USB devices
        - JIT based acceleration using QEMU TCG
        - Frontend designed from scratch for macOS 11 and iOS 11+ using the
          latest and greatest APIs
        - Create, manage, run VMs directly from your device
        - Hardware accelerated virtualization using Hypervisor.framework and
          QEMU
        - Boot macOS guests with Virtualization.framework on macOS 12+

      See https://docs.getutm.app/ for more information.
    '';
    homepage = "https://mac.getutm.app/";
    changelog = "https://github.com/utmapp/utm/releases/tag/v${version}";
    mainProgram = "UTM";
    license = licenses.asl20;
    platforms = platforms.darwin; # 11.3 is the minimum supported version as of UTM 4.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ rrbutani wegank ];
  };
}
