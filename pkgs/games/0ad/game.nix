{ stdenv, lib, perl, fetchurl, python2
, pkgconfig, spidermonkey_38, boost, icu, libxml2, libpng, libsodium
, libjpeg, zlib, curl, libogg, libvorbis, enet, miniupnpc
, openal, libGLU_combined, xproto, libX11, libXcursor, nspr, SDL2
, gloox, nvidia-texture-tools
, withEditor ? true, wxGTK ? null
}:

assert withEditor -> wxGTK != null;

stdenv.mkDerivation rec {
  name = "0ad-${version}";
  version = "0.0.23";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-build.tar.xz";
    sha256 = "0qz1sg4n5y766qwgi63drrrx6k17kk0rcnn9a4a9crllk2vf78fg";
  };

  nativeBuildInputs = [ python2 perl pkgconfig ];

  buildInputs = [
    spidermonkey_38 boost icu libxml2 libpng libjpeg
    zlib curl libogg libvorbis enet miniupnpc openal
    libGLU_combined xproto libX11 libXcursor nspr SDL2 gloox
    nvidia-texture-tools libsodium
  ] ++ lib.optional withEditor wxGTK;

  NIX_CFLAGS_COMPILE = [
    "-I${xproto}/include/X11"
    "-I${libX11.dev}/include/X11"
    "-I${libXcursor.dev}/include/X11"
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
    install -Dm755 -t $out/share/0ad/data/l10n binaries/data/l10n/*

    # Copy libraries.
    install -Dm644 -t $out/lib/0ad        binaries/system/*.so

    # Copy icon.
    install -D build/resources/0ad.png     $out/share/icons/hicolor/128x128/0ad.png
    install -D build/resources/0ad.desktop $out/share/applications/0ad.desktop
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
