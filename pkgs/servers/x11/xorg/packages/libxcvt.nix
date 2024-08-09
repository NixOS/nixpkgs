{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcvt";
  version = "0.1.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcvt";
    rev = "refs/tags/libxcvt-0.1.2";
    hash = "sha256-r72BE+WCZngaMutOxidnJyQ1IpXPFH5NXBs/7l5agD4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
