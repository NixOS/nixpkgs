{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, SDL2, alsaLib, gtk3
, makeWrapper, libGLU_combined, libarchive, libao, unzip, xdg_utils, gsettings-desktop-schemas
, epoxy, gdk_pixbuf, gnome3, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "1.47";
  name = "nestopia-${version}";

  src = fetchFromGitHub {
    owner = "rdanbrook";
    repo = "nestopia";
    rev = "${version}";
    sha256 = "0frr0gvjh5mxzdhj0ii3sh671slgnzlm8naqlc4h87rx4p4sz2y2";
  };

  # nondeterministic failures when creating directories
  enableParallelBuilding = false;

  hardeningDisable = [ "format" ];

  buildInputs = [
    SDL2
    alsaLib
    epoxy
    gtk3
    gdk_pixbuf
    libGLU_combined
    libarchive
    libao
    unzip
    xdg_utils
    gnome3.adwaita-icon-theme
  ];

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
    wrapGAppsHook
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/nestopia}
    make install PREFIX=$out
  '';

  preFixup = ''
     for f in $out/bin/*; do
       wrapProgram $f \
         --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
     done
  '';

  patches = [
    #(fetchpatch {
    #  url = "https://github.com/rdanbrook/nestopia/commit/f4bc74ac4954328b25e961e7afb7337377084079.patch";
    #  name = "gcc6.patch";
    #  sha256 = "1jy0c85xsfk9hrv5a6v0kk48d94864qb62yyni9fp93kyl33y2p4";
    #})
    ./gcc6.patch
    ./build-fix.patch
  ];

  meta = {
    homepage = http://0ldsk00l.ca/nestopia/;
    description = "NES emulator with a focus on accuracy";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

