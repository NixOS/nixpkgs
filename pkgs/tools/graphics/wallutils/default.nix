{ buildGoPackage, fetchFromGitHub, lib
, wayland, libX11, xbitmaps, libXcursor, libXmu, libXpm
}:

buildGoPackage rec {
  pname = "wallutils";
  version = "5.8.3";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "1cc0bb6bdh3pm9mf6rcgk9myr62xhqc6l84xgw44lhm6hkkp16gb";
  };

  goPackagePath = "github.com/xyproto/wallutils";

  patches = [ ./lscollection-Add-NixOS-paths-to-DefaultWallpaperDirectories.patch ];

  postPatch = ''
    # VersionString is sometimes not up-to-date:
    sed -iE 's/VersionString = "[0-9].[0-9].[0-9]"/VersionString = "${version}"/' wallutils.go
  '';

  buildInputs = [ wayland libX11 xbitmaps libXcursor libXmu libXpm ];

  meta = with lib; {
    description = "Utilities for handling monitors, resolutions, and (timed) wallpapers";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
