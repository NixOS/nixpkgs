{ fetchFromGitLab, fprintd, libfprint-tod }:

(fprintd.override { libfprint = libfprint-tod; }).overrideAttrs (oldAttrs:
  let
    pname = "fprintd-tod";
    version = "1.90.9";
  in {
    inherit pname version;

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "libfprint";
      repo = "${oldAttrs.pname}";
      rev = "v${version}";
      sha256 = "sha256-rOTVThHOY/Q2IIu2RGiv26UE2V/JFfWWnfKZQfKl5Mg=";
    };
  })
