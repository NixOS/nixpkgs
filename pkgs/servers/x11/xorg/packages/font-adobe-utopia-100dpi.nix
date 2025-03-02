{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-utopia-100dpi";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "adobe-utopia-100dpi";
    rev = "refs/tags/font-adobe-utopia-100dpi-1.0.5";
    hash = "sha256-sAnbp+DBOVzWOSvMXapKNg4znRAag2EKctlRkG3yZUM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
