{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config

, curl
, freetype
, glew
, gtk2
, libGL
, libjpeg
, libpng
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_mixer
, SDL2_ttf
}:

stdenv.mkDerivation {
  pname = "principia";
  version = "unstable-2023-03-21";

  src = fetchFromGitHub {
    owner = "Bithack";
    repo = "principia";
    rev = "af2cfda21b6ce4c0725700e2a01b0597a97dbeff";
    hash = "sha256-jBWdXzbPpk23elHcs5sWkxXfkekj+aa24VvEHzid8KE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    freetype
    glew
    gtk2
    libGL
    libjpeg
    libpng
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  preAutoreconf = ''
    cd build-linux
  '';

  # Since we bypass the "build-linux/go" wrapper script so we can use nixpkgs'
  # autotools/make integration, set the release flags manually.
  # https://github.com/Bithack/principia/issues/98
  preBuild = ''
    RELEASE_SHARED="-ffast-math -DNDEBUG=1 -s -fomit-frame-pointer -fvisibility=hidden -fdata-sections -ffunction-sections"
    makeFlagsArray+=(
      CFLAGS="$RELEASE_SHARED -O1"
      CXXFLAGS="$RELEASE_SHARED -O2 -fvisibility-inlines-hidden -fno-rtti"
      LDFLAGS="-Wl,-O,-s,--gc-sections"
    )
  '';

  # `make install` only installs the binary, and the binary looks for data
  # files in its same directory, so we override installPhase, install the
  # binary in $out/share, and link to it from $out/bin
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/principia
    install -Dm755 principia $out/share/principia/principia
    ln -s $out/share/principia/principia $out/bin/principia

    cp -r --dereference data-pc data-shared $out/share/principia/
    install -Dm644 principia.desktop $out/share/applications/principia.desktop
    install -Dm644 principia-url-handler.desktop $out/share/applications/principia-url-handler.desktop
    install -Dm644 principia.png $out/share/pixmaps/principia.png

    runHook postInstall
  '';

  # The actual binary is here, see comment above installPhase
  stripDebugList = [ "share/principia" ];

  meta = with lib; {
    description = "Physics-based sandbox game";
    homepage = "https://principia-web.se/";
    downloadPage = "https://principia-web.se/download";
    license = licenses.bsd3;
    maintainers = [ maintainers.fgaz ];
    platforms = platforms.linux;
  };
}
