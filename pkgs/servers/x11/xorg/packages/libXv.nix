{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXv";
  version = "1.0.12";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXv";
    rev = "refs/tags/libXv-1.0.12";
    hash = "sha256-32aiI59SRHpiQKiURDlwlf6zKg/lmBcPnej1sT+O+Eo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
