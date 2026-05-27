{
  aha,
  clinfo,
  dmidecode,
  iproute2,
  lib,
  libdisplay-info,
  libusb1,
  lm_sensors,
  mesa-demos,
  mkKdeDerivation,
  pkg-config,
  pciutils,
  pulseaudio,
  qttools,
  replaceVars,
  systemsettings,
  util-linux,
  vulkan-tools,
  wayland-utils,
  xdpyinfo,
}:
let
  tools = {
    aha = lib.getExe aha;
    clinfo = lib.getExe clinfo;
    di_edid_decode = lib.getExe libdisplay-info;
    dmidecode = lib.getExe' dmidecode "dmidecode";
    eglinfo = lib.getExe' mesa-demos "eglinfo";
    glxinfo = lib.getExe' mesa-demos "glxinfo";
    ip = lib.getExe' iproute2 "ip";
    lsblk = lib.getExe' util-linux "lsblk";
    lspci = lib.getExe' pciutils "lspci";
    lscpu = lib.getExe' util-linux "lscpu";
    pactl = lib.getExe' pulseaudio "pactl";
    qdbus = lib.getExe' qttools "qdbus";
    sensors = lib.getExe' lm_sensors "sensors";
    vulkaninfo = lib.getExe' vulkan-tools "vulkaninfo";
    waylandinfo = lib.getExe wayland-utils;
    xdpyinfo = lib.getExe xdpyinfo;
  };
in
mkKdeDerivation {
  pname = "kinfocenter";

  patches = [
    # fwupdmgr is provided through NixOS' module
    (replaceVars ./0001-tool-paths.patch (
      {
        # @QtBinariesDir@ only appears in the *removed* lines of the diff
        QtBinariesDir = null;
      }
      // tools
    ))
  ];

  postPatch = ''
    substituteInPlace kcms/firmware_security/fwupdmgr.sh \
      --replace-fail " aha " " ${lib.getExe aha} "
  '';

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ libusb1 ];

  qtWrapperArgs = [ "--inherit-argv0" ];

  # fix wrong symlink of infocenter pointing to a 'systemsettings5' binary in
  # the same directory, while it is actually located in a completely different
  # store path
  preFixup = ''
    ln -sf ${systemsettings}/bin/systemsettings $out/bin/kinfocenter
  '';

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lib.concatStringsSep ":" (lib.attrValues tools)}" > $out/nix-support/depends
  '';

  meta.mainProgram = "kinfocenter";
}
