{ buildGoModule, fetchFromGitHub, lib
, wayland, libX11, xbitmaps, libXcursor, libXmu
}:

buildGoModule rec {
  name = "wallutils-${version}";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "1q4487s83iwwgd40hkihpns84ya8mg54zp63ag519cdjizz38xyi";
  };

  modSha256 = "0kj9s9ymd99a5w9r1d997qysnzlgpnmh5dnki33h1jlwz47nwkld";

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
