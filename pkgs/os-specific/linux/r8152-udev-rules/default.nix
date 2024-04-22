{ stdenv
, fetchFromGitHub
, lib
}:
stdenv.mkDerivation rec {
  pname = "r8152-udev-rules";
  version = "2.16.3.20221209";

  src = fetchFromGitHub {
    owner = "wget";
    repo = "realtek-r8152-linux";
    rev = "v${version}";
    sha256 = "sha256-RaYuprQFbWAy8CtSZOau0Qlo3jtZnE1AhHBgzASopSA=";
  };

  # We don't want to build the kernel module
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/udev/rules.d
    cp 50-usb-realtek-net.rules $out/lib/udev/rules.d/
    runHook postInstall
  '';

  meta = {
    description = "Udev rules for Realtek RTL8152/RTL8153 USB Ethernet adapters.";
    license = lib.licenses.gpl2Only;
    homepage = "https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-usb-3-0-software";
    maintainers = with lib.maintainers; [ accelbread ];
    platforms = lib.platforms.linux;
  };
}
