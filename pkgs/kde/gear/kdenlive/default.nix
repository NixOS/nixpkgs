{
  mkKdeDerivation,
  substituteAll,
  qtsvg,
  qtmultimedia,
  qtnetworkauth,
  qqc2-desktop-style,
  ffmpeg-full,
  mediainfo,
  mlt,
  shared-mime-info,
  libv4l,
  frei0r,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kdenlive";

  patches = [
    (
      substituteAll {
        src = ./dependency-paths.patch;
        inherit mediainfo mlt;
        ffmpeg = ffmpeg-full;
      }
    )

    # Backport fix for crash after 5 minutes
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://invent.kde.org/multimedia/kdenlive/-/commit/8be0e826471332bb739344ebe1859298c46e9e0f.patch";
      hash = "sha256-5hLePH5NlO4Lx8lg9kjBPI4jTmP666RGplaVCmS/9TA=";
    })
  ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qtnetworkauth

    qqc2-desktop-style

    mlt
    shared-mime-info
    libv4l
  ];

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
  ];
}
