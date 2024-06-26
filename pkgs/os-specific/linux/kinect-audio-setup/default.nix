{
  lib,
  stdenv,
  fetchgit,
  requireFile,
  pkg-config,
  libusb1,
  p7zip,
}:

let
  # The last known good firmware package to have been tested
  # by the upstream projet.
  # The firmware URL is hardcoded in the upstream project's installation script
  firmwareUrl = "https://download.microsoft.com/download/F/9/9/F99791F2-D5BE-478A-B77A-830AD14950C3/KinectSDK-v1.0-beta2-x86.msi";
  # The original URL "https://research.microsoft.com/en-us/um/legal/kinectsdk-tou_noncommercial.htm"
  # redirects to the following url:
  licenseUrl = "https://www.microsoft.com/en-us/legal/terms-of-use";
in
stdenv.mkDerivation rec {
  pname = "kinect-audio-setup";

  # On update: Make sure that the `firmwareURL` is still in sync with upstream.
  # If the project structure hasn't changed you can find the URL in the
  # `kinect_fetch_fw` file in the project source.
  version = "0.5";

  # This is an MSI or CAB file
  FIRMWARE = requireFile rec {
    name = "UACFirmware";
    sha256 = "08a2vpgd061cmc6h3h8i6qj3sjvjr1fwcnwccwywqypz3icn8xw1";
    message = ''
      In order to install the Kinect Audio Firmware, you need to download the
      non-redistributable firmware from Microsoft.
      The firmware is available at ${firmwareUrl} and the license at ${licenseUrl} .
      Save the file as UACFirmware and use "nix-prefetch-url file://\$PWD/UACFirmware" to
      add it to the Nix store.
    '';
  };

  src = fetchgit {
    url = "git://git.ao2.it/kinect-audio-setup.git";
    rev = "v${version}";
    sha256 = "sha256-bFwmWh822KvFwP/0Gu097nF5K2uCwCLMB1RtP7k+Zt0=";
  };

  # These patches are not upstream because the project has seen no
  # activity since 2016
  patches = [
    ./libusb-1-import-path.patch
    ./udev-rules-extra-devices.patch
  ];

  nativeBuildInputs = [
    p7zip
    libusb1
    pkg-config
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR=$(out)"
    "FIRMWARE_PATH=$(out)/lib/firmware/UACFirmware"
    "LOADER_PATH=$(out)/libexec/kinect_upload_fw"
  ];

  buildPhase = ''
    runHook preBuild
    make -C kinect_upload_fw kinect_upload_fw $makeFlags "''${makeFlagsArray[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/ $out/lib/firmware $out/lib/udev/rules.d

    install -Dm755 kinect_upload_fw/kinect_upload_fw $out/libexec/

    # 7z extract "assume yes on all queries" "only extract/keep files/directories matching UACFIRMWARE.* recursively"
    7z e -y -r "${FIRMWARE}" "UACFirmware.*" >/dev/null
    # The filename is bound to change with the Firmware SDK
    mv UACFirmware.* $out/lib/firmware/UACFirmware

    make install_udev_rules $makeFlags "''${makeFlagsArray[@]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools to enable audio input from the Microsoft Kinect sensor device";
    homepage = "https://git.ao2.it/kinect-audio-setup.git";
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
