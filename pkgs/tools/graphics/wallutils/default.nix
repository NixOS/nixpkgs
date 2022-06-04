{ buildGoModule
, fetchFromGitHub
, lib
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
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "1phlkpy8kg4ai2xmachpbbxvl8fga9hqqbad2a2121yl60709l1k";
  };

  vendorSha256 = null;

  patches = [ ./lscollection-Add-NixOS-paths-to-DefaultWallpaperDirectories.patch ];

  postPatch = ''
    # VersionString is sometimes not up-to-date:
    sed -iE 's/VersionString = "[0-9].[0-9].[0-9]"/VersionString = "${version}"/' wallutils.go
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ wayland libX11 xbitmaps libXcursor libXmu libXpm libheif ];

  ldflags = [ "-s" "-w" ];

  # Disable tests require desktop environment
  doCheck = false;

  meta = with lib; {
    description = "Utilities for handling monitors, resolutions, and (timed) wallpapers";
    homepage = https://github.com/xyproto/wallutils;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
