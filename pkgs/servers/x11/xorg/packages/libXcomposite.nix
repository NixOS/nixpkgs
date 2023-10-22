{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXcomposite";
  version = "0.4.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXcomposite";
    rev = "refs/tags/libXcomposite-0.4.6";
    hash = "sha256-oc8r6QKZDrBjQcm6SOtHvYoJlZPU1+9qDJ2Pfnj/c80=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
