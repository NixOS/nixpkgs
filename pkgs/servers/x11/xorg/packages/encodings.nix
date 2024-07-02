{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "encodings";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "encodings";
    rev = "refs/tags/encodings-1.0.7";
    hash = "sha256-LuCigYLVmZn8To8YF6p03ezsWOBIv2aZUUJl1ToWtk0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
