{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-sony-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "sony-misc";
    rev = "refs/tags/font-sony-misc-1.0.4";
    hash = "sha256-wXMIrefO8pYlphWVNooyAwNjMV8YBbjWtgV8hdhXNZM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
