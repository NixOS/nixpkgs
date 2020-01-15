{ buildGoModule, fetchFromGitHub, lib
, wayland, libX11, xbitmaps, libXcursor, libXmu, libXpm
}:

buildGoModule rec {
  pname = "wallutils";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "1ghvcxsy5prj8l38r4lg39imsqbwmvn1zmiv7004j6skmgpaaawh";
  };

  modSha256 = "0siw1g3fsk1xjri9k1pb03filax8an5sfza5db52krh80g9xasah";

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
