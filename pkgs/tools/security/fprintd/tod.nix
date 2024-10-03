{ lib
, fetchFromGitLab
, fprintd
, libfprint-tod
}:

(fprintd.override { libfprint = libfprint-tod; }).overrideAttrs (oldAttrs: rec {
    pname = "fprintd-tod";
    version = "1.94.3";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "libfprint";
      repo = "fprintd";
      rev = "v${version}";
      sha256 = "sha256-shH+ctQAx4fpTMWTmo3wB45ZS38Jf8RknryPabfZ6QE=";
    };

    meta = {
      homepage = "https://fprint.freedesktop.org/";
      description = "fprintd built with libfprint-tod to support Touch OEM Drivers";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ hmenke ];
    };
  })
