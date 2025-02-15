{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-cyrillic";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "misc-cyrillic";
    rev = "refs/tags/font-misc-cyrillic-1.0.4";
    hash = "sha256-MJVn3BlLrJhDwBHN8JAKTAkYFzxAWhhOOaox8Dq45Ko=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
