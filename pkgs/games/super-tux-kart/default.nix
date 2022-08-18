{ lib
, stdenv
, fetchFromGitHub
, fetchsvn
, cmake
, pkg-config
, makeWrapper
, SDL2
, glew
, openal
, OpenAL
, libvorbis
, libogg
, curl
, freetype
, libjpeg
, libpng
, harfbuzz
, mcpp
, wiiuse
, angelscript
, libopenglrecorder
, sqlite
, Cocoa
, IOKit
, libsamplerate
}:
let
  assets = fetchsvn {
    url = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
    rev = "18464";
    sha256 = "1a84j3psl4cxzkn5ynakpjill7i2f9ki2p729bpmbrvg8fki95aa";
    name = "stk-assets";
  };

  # List of bundled libraries in stk-code/lib to keep
  # Those are the libraries that cannot be replaced
  # with system packages.
  bundledLibraries = [
    # Bullet 2.87 is incompatible (bullet 2.79 needed whereas 2.87 is packaged)
    # The api changed in a lot of classes, too much work to adapt
    "bullet"
    # Upstream Libenet doesn't yet support IPv6,
    # So we will use the bundled libenet which
    # has been fixed to support it.
    "enet"
    # Internal library of STK, nothing to do about it
    "graphics_engine"
    # Internal library of STK, nothing to do about it
    "graphics_utils"
    # This irrlicht is bundled with cmake
    # whereas upstream irrlicht still uses
    # archaic Makefiles, too complicated to switch to.
    "irrlicht"
    # Not packaged to this date
    "libsquish"
    # Not packaged to this date
    "sheenbidi"
    # Not packaged to this date
    "tinygettext"
    # Not packaged to this date (needed on Darwin)
    "mojoal"
  ];
in
stdenv.mkDerivation rec {

  pname = "supertuxkart";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "supertuxkart";
    repo = "stk-code";
    rev = version;
    sha256 = "1llyxkdc4m9gnjxqaxlpwvv3ayvpw2bfjzfkkrljaxhznq811g0l";
  };

  postPatch = ''
    # Deletes all bundled libs in stk-code/lib except those
    # That couldn't be replaced with system packages
    find lib -maxdepth 1 -type d | egrep -v "^lib$|${(lib.concatStringsSep "|" bundledLibraries)}" | xargs -n1 -L1 -r -I{} rm -rf {}

    # Allow building with system-installed wiiuse on Darwin
    substituteInPlace CMakeLists.txt \
      --replace 'NOT (APPLE OR HAIKU)) AND USE_SYSTEM_WIIUSE' 'NOT (HAIKU)) AND USE_SYSTEM_WIIUSE'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL2
    glew
    libvorbis
    libogg
    freetype
    curl
    libjpeg
    libpng
    harfbuzz
    mcpp
    wiiuse
    angelscript
    sqlite
  ]
  ++ lib.optional (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isLinux) libopenglrecorder
  ++ lib.optional stdenv.hostPlatform.isLinux openal
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ OpenAL IOKit Cocoa libsamplerate ];

  cmakeFlags = [
    "-DBUILD_RECORDER=${lib.boolToCMakeString (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isLinux)}"
    "-DUSE_SYSTEM_ANGELSCRIPT=ON"
    "-DCHECK_ASSETS=OFF"
    "-DUSE_SYSTEM_WIIUSE=ON"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  # Extract binary from built app bundle
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/bin
    mv $out/{supertuxkart.app/Contents/MacOS,bin}/supertuxkart
    rm -rf $out/supertuxkart.app
  '';

  # Obtain the assets directly from the fetched store path, to avoid duplicating assets across multiple engine builds
  preFixup = ''
    wrapProgram $out/bin/supertuxkart \
      --set-default SUPERTUXKART_ASSETS_DIR "${assets}" \
      --set-default SUPERTUXKART_DATADIR "$out/share/supertuxkart" \
  '';

  meta = with lib; {
    description = "A Free 3D kart racing game";
    longDescription = ''
      SuperTuxKart is a Free 3D kart racing game, with many tracks,
      characters and items for you to try, similar in spirit to Mario
      Kart.
    '';
    homepage = "https://supertuxkart.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pyrolagus peterhoeg ];
    platforms = with platforms; unix;
    changelog = "https://github.com/supertuxkart/stk-code/blob/${version}/CHANGELOG.md";
  };
}
