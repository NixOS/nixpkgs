{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wayland
, libX11
, xbitmaps
, libXcursor
, libXmu
, libXpm
, libheif
}:

buildGoModule rec {
  pname = "wallutils";
  version = "5.12.4";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "sha256-NODG4Lw/7X1aoT+dDSWxWEbDX6EAQzzDJPwsWOLaJEM=";
  };

  vendorSha256 = null;

  patches = [ ./lscollection-Add-NixOS-paths-to-DefaultWallpaperDirectories.patch ];

  excludedPackages = [
    "./pkg/event/cmd" # Development tools
  ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ wayland libX11 xbitmaps libXcursor libXmu libXpm libheif ];

  preCheck =
    let skippedTests = [
      "TestClosest" # Requiring Wayland or X.
      "TestNewSimpleEvent" # Blocking
      "TestEveryMinute" # Blocking
    ]; in
    ''
      export XDG_RUNTIME_DIR=`mktemp -d`

      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  meta = with lib; {
    description = "Utilities for handling monitors, resolutions, and (timed) wallpapers";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
