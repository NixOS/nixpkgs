{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, udev
, libX11
, libXcursor
, libXinerama
, libXrandr
, libXrender
, libpulseaudio
, libXi
, libXext
, libXfixes
, openssl
, alsa-lib
, libGLU
, yasm
, withUdev ? true
, cacert
, bullet
, enet
, freetype
# , glslang
, libogg
, libpng
, libtheora
, libvorbis
, libwebp
# , wslay
, mbedtls
, miniupnpc
, libopus
, pcre2
# , squish
, vulkan-loader
, zlib
, zstd
, harfbuzzFull
, graphite2
, icu
}:

let
  options = {
    touch = libXi != null;
    pulseaudio = false;
    udev = withUdev;
  };
in
stdenv.mkDerivation rec {
  pname = "godot";
  version = "unstable-2022-02-08";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "jpakkane";
    repo = "godot";
    rev = "f9996d487ef87f279ebd2c3c7cc34b2c7e518665";
    sha256 = "RtXK/cNeu54EPvKMcN4XZMZJZqhSQklBZTCEyVVoZsg=";
  };

  patches = [
    # ./pkg_config_additions.patch
    # ./dont_clobber_environment.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    udev
    libX11
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libXi
    libXext
    libXfixes
    freetype
    openssl
    alsa-lib
    libpulseaudio
    libGLU
    zlib
    yasm

    bullet
    enet
    freetype
    # glslang
    libogg
    libpng
    libtheora
    libvorbis
    libwebp
    # wslay
    mbedtls
    miniupnpc
    libopus
    pcre2
    # squish
    vulkan-loader
    zlib
    zstd
    harfbuzzFull
    graphite2
    icu
  ];

  mesonFlags = [
    # "-Ddebug=true"
    "-Dbuiltin_bullet=false"
    "-Dbuiltin_certs=false"
    "-Dsystem_certs_path=${cacert}/etc/ssl/certs/ca-bundle.crt"
    "-Dbuiltin_enet=false"
    "-Dbuiltin_freetype=false"
    "-Dbuiltin_libogg=false"
    "-Dbuiltin_libpng=false"
    "-Dbuiltin_libtheora=false"
    "-Dbuiltin_libvorbis=false"
    "-Dbuiltin_libwebp=false"
    # "-Dbuiltin_squish=false" # not packaged
    # "-Dbuiltin_vulkan=false" # depends on other libraries
    "-Dbuiltin_zlib=false"
    "-Dbuiltin_zstd=false"

    "-Dbuiltin_harfbuzz=false"
    "-Dbuiltin_graphite=false"
    # "-Dbuiltin_icu=false" # some tools depend on data file not present in the package
  ];

  mesonBuildType = "debug";

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs \
      core/object/make_virtuals.py \
      scripts/scons_compat.py
  '';

  installPhase = ''
    runHook preInstall

    # Switch back to source directory
    cd ..

    mkdir -p "$out/bin"
    # cp bin/godot.* $out/bin/godot

    mkdir "$dev"
    cp -r modules/gdnative/include $dev

    mkdir -p "$man/share/man/man6"
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ twey ];
  };
}
