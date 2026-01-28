{
  stdenv,
  fetchFromGitHub,
  xorg-server,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "xf86-video-scfb";
  version = "0.0.7";
  src = fetchFromGitHub {
    owner = "rayddteam";
    repo = pname;
    rev = version;
    hash = "sha256-hYBGnk/lpVOrl05tN6kXxEft6QktU5432wgZ8a+WdZc=";
  };

  postPatch = ''
    sed -E -i -e "/xf86DisableRandR/d" src/scfb_driver.c
  '';

  buildInputs = [ xorg-server ];
  nativeBuildInputs = [ pkg-config ];
}
