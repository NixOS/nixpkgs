{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fonttosfnt";
  version = "1.2.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "fonttosfnt";
    rev = "refs/tags/fonttosfnt-1.2.3";
    hash = "sha256-Z2zDe+YHoAkrXy9O+WvDVUnj4o88+j2KsiGQR/CRre4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
