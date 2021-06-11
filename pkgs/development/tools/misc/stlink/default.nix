{ lib
, stdenv
, fetchFromGitHub
, cmake
, libusb1
, gtk3
, pkg-config
, wrapGAppsHook
, withGUI ? false
}:

let
  # The Darwin build of stlink explicitly refers to static libusb.
  libusb1' = if stdenv.isDarwin then libusb1.override { withStatic = true; } else libusb1;

# IMPORTANT: You need permissions to access the stlink usb devices.
# Add services.udev.packages = [ pkgs.stlink ] to your configuration.nix

in stdenv.mkDerivation rec {
  pname = "stlink";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "stlink-org";
    repo = "stlink";
    rev = "v${version}";
    sha256 = "03xypffpbp4imrczbxmq69vgkr7mbp0ps9dk815br5wwlz6vgygl";
  };

  buildInputs = [
    libusb1'
  ] ++ lib.optionals withGUI [
    gtk3
  ];
  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals withGUI [
    pkg-config
    wrapGAppsHook
  ];

  cmakeFlags = [
    "-DSTLINK_MODPROBED_DIR=${placeholder "out"}/etc/modprobe.d"
    "-DSTLINK_UDEV_RULES_DIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = with lib; {
    description = "In-circuit debug and programming for ST-Link devices";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor maintainers.rongcuid ];
  };
}
