{ stdenv, lib, callPackage, perl, fetchurl, python2
, pkgconfig, spidermonkey_38, boost, icu, libxml2, libpng
, libjpeg, zlib, curl, libogg, libvorbis, enet, miniupnpc
, openal, libGLU_combined, xproto, libX11, libXcursor, nspr, SDL, SDL2
, gloox, nvidia-texture-tools
, withEditor ? true, wxGTK ? null
}:

assert withEditor -> wxGTK != null;

stdenv.mkDerivation rec {
  name = "0ad-${version}";
  version = "0.0.22";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-build.tar.xz";
    sha256 = "1cgmr4g5g9wv36v7ylbrvqhsjwgcsdgbqwc8zlqmnayk9zgkdpgx";
  };

  nativeBuildInputs = [ python2 perl pkgconfig ];

  buildInputs = [
    spidermonkey_38 boost icu libxml2 libpng libjpeg
    zlib curl libogg libvorbis enet miniupnpc openal
    libGLU_combined xproto libX11 libXcursor nspr SDL2 gloox
    nvidia-texture-tools
  ] ++ lib.optional withEditor wxGTK;

  NIX_CFLAGS_COMPILE = [
    "-I${xproto}/include/X11"
    "-I${libX11.dev}/include/X11"
    "-I${libXcursor.dev}/include/X11"
    "-I${SDL.dev}/include/SDL"
    "-I${SDL2}/include/SDL2"
  ];

  patches = [ ./rootdir_env.patch ];

  postPatch = ''
    sed -i 's/MOZJS_MINOR_VERSION/false \&\& MOZJS_MINOR_VERSION/' source/scriptinterface/ScriptTypes.h
  '';

  configurePhase = ''
    # Delete shipped libraries which we don't need.
    rm -rf libraries/source/{enet,miniupnpc,nvtt,spidermonkey}

    # Workaround invalid pkgconfig name for mozjs
    mkdir pkgconfig
    ln -s ${spidermonkey_38}/lib/pkgconfig/* pkgconfig/mozjs-38.pc
    PKG_CONFIG_PATH="$PWD/pkgconfig:$PKG_CONFIG_PATH"

    # Update Makefiles
    pushd build/workspaces
    ./update-workspaces.sh \
      --with-system-nvtt \
      --with-system-mozjs38 \
      ${lib.optionalString withEditor "--enable-atlas"} \
      --bindir="$out"/bin \
      --libdir="$out"/lib/0ad \
      --without-tests \
      -j $NIX_BUILD_CORES
    popd

    # Move to the build directory.
    pushd build/workspaces/gcc
  '';

  enableParallelBuilding = true;

  installPhase = ''
    popd

    # Copy executables.
    install -Dm755 binaries/system/pyrogenesis "$out"/bin/0ad
    ${lib.optionalString withEditor ''
      install -Dm755 binaries/system/ActorEditor "$out"/bin/ActorEditor
    ''}

    # Copy l10n data.
    mkdir -p "$out"/share/0ad/data
    cp -r binaries/data/l10n "$out"/share/0ad/data

    # Copy libraries.
    mkdir -p "$out"/lib/0ad
    cp binaries/system/*.so "$out"/lib/0ad/

    # Copy icon.
    install -D build/resources/0ad.png "$out"/share/icons/hicolor/128x128/0ad.png
    install -D build/resources/0ad.desktop "$out"/share/applications/0ad.desktop
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source game of ancient warfare";
    homepage = "https://play0ad.com/";
    license = with licenses; [
      gpl2 lgpl21 mit cc-by-sa-30
      licenses.zlib # otherwise masked by pkgs.zlib
    ];
    platforms = subtractLists platforms.i686 platforms.linux;
  };
}
