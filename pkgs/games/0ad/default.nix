{ stdenv, callPackage, fetchurl, python27
, pkgconfig, spidermonkey_31, boost, icu, libxml2, libpng
, libjpeg, zlib, curl, libogg, libvorbis, enet, miniupnpc
, openal, mesa, xproto, libX11, libXcursor, nspr, SDL, SDL2
, gloox, nvidia-texture-tools
, withEditor ? true, wxGTK ? null
}:

assert withEditor -> wxGTK != null;

let
  version = "0.0.20";

  releaseType = "alpha";

  zeroadData = callPackage ./data.nix { inherit version releaseType; };

  archForPremake =
    if stdenv.lib.hasPrefix "x86_64-" stdenv.system then "x64" else
    if stdenv.lib.hasPrefix "i686-" stdenv.system then "x32" else "ERROR";

in
stdenv.mkDerivation rec {
  name = "0ad-${version}";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-${releaseType}-unix-build.tar.xz";
    sha256 = "13n61xhjsawda3kl7112la41bqkbqmq4yhr3slydsz856z5xb5m3";
  };

  buildInputs = [
    zeroadData python27 pkgconfig spidermonkey_31 boost icu
    libxml2 libpng libjpeg zlib curl libogg libvorbis enet
    miniupnpc openal mesa xproto libX11 libXcursor nspr
    SDL SDL2 gloox nvidia-texture-tools
  ] ++ stdenv.lib.optional withEditor wxGTK;

  NIX_CFLAGS_COMPILE = [
    "-I${xproto}/include/X11"
    "-I${libX11}/include/X11"
    "-I${libXcursor}/include/X11"
    "-I${SDL}/include/SDL"
    "-I${SDL2}/include/SDL2"
  ];

  patchPhase = ''
    sed -i 's/MOZJS_MINOR_VERSION/false \&\& MOZJS_MINOR_VERSION/' source/scriptinterface/ScriptTypes.h
  '';

  configurePhase = ''
    # Delete shipped libraries which we don't need.
    rm -rf libraries/source/{enet,miniupnpc,nvtt,spidermonkey}

    # Build shipped premake.
    make -C build/premake/premake4/build/gmake.unix

    # Run premake.
    pushd build/premake
    ./premake4/bin/release/premake4 \
      --file="premake4.lua" \
      --outpath="../workspaces/gcc/" \
      --platform=${archForPremake} \
      --os=linux \
      --with-system-nvtt \
      --with-system-enet \
      --with-system-miniupnpc \
      --with-system-mozjs31 \
      ${ if withEditor then "--atlas" else "" } \
      --collada \
      --bindir="$out"/bin \
      --libdir="$out"/lib/0ad \
      --datadir="$out"/share/0ad \
      --without-tests \
      gmake
    popd
  '';

  buildPhase = ''
    # Build bundled fcollada.
    make -C libraries/source/fcollada/src

    # Build 0ad.
    make -C build/workspaces/gcc verbose=1
  '';

  installPhase = ''
    # Copy executables.
    mkdir -p "$out"/bin
    cp binaries/system/pyrogenesis "$out"/bin/0ad
    ((${ toString withEditor })) && cp binaries/system/ActorEditor "$out"/bin/

    # Copy l10n data.
    mkdir -p "$out"/share/0ad
    cp -r binaries/data/l10n "$out"/share/0ad/

    # Copy libraries.
    mkdir -p "$out"/lib/0ad
    cp binaries/system/libCollada.so "$out"/lib/0ad/
    ((${ toString withEditor })) && cp binaries/system/libAtlasUI.so "$out"/lib/0ad/

    # Create links to data files.
    ln -s -t "$out"/share/0ad "${zeroadData}"/share/0ad/*

    # Copy icon.
    mkdir -p "$out"/share/icons
    cp build/resources/0ad.png "$out"/share/icons/

    # Copy/fix desktop item.
    mkdir -p "$out"/share/applications
    while read LINE; do
      if [[ $LINE = "Exec=0ad" ]]; then
        echo "Exec=$out/bin/zeroad"
      elif [[ $LINE = "Icon=0ad" ]]; then
        echo "Icon=$out/share/icons/0ad.png"
      else
        echo "$LINE"
      fi
    done <build/resources/0ad.desktop >"$out"/share/applications/0ad.desktop
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source game of ancient warfare";
    homepage = "http://wildfiregames.com/0ad/";
    license = with licenses; [
      gpl2 lgpl21 mit cc-by-sa-30
      licenses.zlib # otherwise masked by pkgs.zlib
    ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    hydraPlatforms = []; # the data are too big (~1.5 GB)
  };
}
