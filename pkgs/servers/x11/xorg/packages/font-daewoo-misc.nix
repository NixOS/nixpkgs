{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-daewoo-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "daewoo-misc";
    rev = "refs/tags/font-daewoo-misc-1.0.4";
    hash = "sha256-8Fdv5CxTHIGqpDU5r4AmZqZuGEXeNMUTTpAb+7fIv5E=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
