{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-ethiopic";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "misc-ethiopic";
    rev = "refs/tags/font-misc-ethiopic-1.0.5";
    hash = "sha256-NblV1ZL8X7y5DwRGqtp8nQXxULNnn74KYL5MMX3XEiQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
