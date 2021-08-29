{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, Cocoa
, IOKit
}:
let
  dir = "stk-code";
  assets = fetchsvn {
    url = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
    rev = "18218";
    sha256 = "11iv3cqzvbjg33zz5i5gkl2syn6mlw9wqv0jc7h36vjnjqjv17xw";
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
    "graphics_utils"
    # This irrlicht is bundled with cmake
    # whereas upstream irrlicht still uses
    # archaic Makefiles, too complicated to switch to.
    "irrlicht"
    # Not packaged to this date
    "libraqm"
    # Not packaged to this date
    "libsquish"
    # Not packaged to this date
    "sheenbidi"
  ]
  # Our system angelscript causes linking error on ARM
  # ld: libangelscript.so: undefined reference to
  # `CallSystemFunctionNative(asCContext*, asCScriptFunction*, void*, unsigned int*, void*, unsigned long&, void*)'
  # Bundled angelscript compiles fine
  ++ lib.optional stdenv.hostPlatform.isAarch64 "angelscript";
in
stdenv.mkDerivation rec {

  pname = "supertuxkart";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "supertuxkart";
    repo = "stk-code";
    rev = version;
    sha256 = "1f98whk0v45jgwcsbdsb1qfambvrnbbgwq0w28kjz4278hinwzq6";
    name = dir;
  };

  patches = [
    (fetchpatch {
      # Fix build with SDL 2.0.14
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/games-action/supertuxkart/files/supertuxkart-1.2-new-sdl.patch?id=288360dc7ce2f968a2f12099edeace3f3ed1a705";
      sha256 = "1jgab9393qan8qbqf5bf8cgw4mynlr5a6pggqhybzsmaczgnns3n";
    })
  ];

  postPatch = ''
    # Deletes all bundled libs in stk-code/lib except those
    # That couldn't be replaced with system packages
    find lib -maxdepth 1 -type d | egrep -v "^lib$|${(lib.concatStringsSep "|" bundledLibraries)}" | xargs -n1 -L1 -r -I{} rm -rf {}

    # Allow building with system-installed wiiuse on Darwin
    substituteInPlace CMakeLists.txt \
      --replace 'NOT (APPLE OR HAIKU)) AND USE_SYSTEM_WIIUSE' 'NOT (HAIKU)) AND USE_SYSTEM_WIIUSE'
  '';

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

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
  ]
  ++ lib.optional (!stdenv.hostPlatform.isAarch64) angelscript
  ++ lib.optional stdenv.hostPlatform.isLinux openal
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ OpenAL IOKit Cocoa ];

  cmakeFlags = [
    "-DBUILD_RECORDER=OFF" # libopenglrecorder is not in nixpkgs
    # doesn't work with our 2.35.0 on aarch64-linux
    "-DUSE_SYSTEM_ANGELSCRIPT=${if !stdenv.hostPlatform.isAarch64 then "ON" else "OFF"}"
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
