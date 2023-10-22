{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-screen-cyrillic";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "screen-cyrillic";
    rev = "refs/tags/font-screen-cyrillic-1.0.5";
    hash = "sha256-kiy4XhMi2NEIbgVQyYJDZipaxjksISzU1KS7Nuw1gyw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
