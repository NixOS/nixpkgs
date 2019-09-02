{ buildGoModule, fetchFromGitHub, lib
, wayland, libX11, xbitmaps, libXcursor, libXmu
}:

buildGoModule rec {
  pname = "wallutils";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "095pgvk4yp2l6xgl63qp61rr2dij51awndwrs5ha9vpdd1jqgvfi";
  };

  modSha256 = "1kbggry1qrf0nkvysnaky2nl73l5f0bnc4wx0hfr6ifyagfjzy77";

  patches = [ ./lscollection-Add-NixOS-paths-to-DefaultWallpaperDirectories.patch ];

  postPatch = ''
    # VersionString is sometimes not up-to-date:
    sed -iE 's/VersionString = "[0-9].[0-9].[0-9]"/VersionString = "${version}"/' wallutils.go
  '';

  buildInputs = [ wayland libX11 xbitmaps libXcursor libXmu ];

  meta = with lib; {
    description = "Utilities for handling monitors, resolutions, and (timed) wallpapers";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
