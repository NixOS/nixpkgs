{ buildGoModule, fetchFromGitHub, lib
, wayland, libX11, xbitmaps, libXcursor, libXmu
}:

buildGoModule rec {
  name = "wallutils-${version}";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
    sha256 = "1s9k2fwckpm1zpdxywckwbql38h0sp6y9ji88rxss7yjc2g12zaf";
  };

  modSha256 = "0rfmqmm0jld7zrv192dqv7khwb2xm9i77sa1wgr7q6afdhbkrm21";

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
