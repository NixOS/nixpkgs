{stdenv
,cargo
,lib
,perl
,fetchurl
,fmt
,pkg-config
,boost
,icu67
,libxml2
,libpng
,libsodium
,libjpeg
,zlib
,curl
,libogg
,libvorbis
,enet
,miniupnpc
,openal
,libGLU
,libGL
,xorgproto
,libX11
,libXcursor
,nspr
,SDL2
,gloox
,nvidia-texture-tools
,libidn
,rustc
,rust-cbindgen
,python3
,yasm
,readline
,autoconf213
,llvmPackages
,which
,zip
,xorg
,buildPackages
,cargo-c
,withEditor ? true, wxGTK ? null
}:
assert withEditor -> wxGTK != null;

stdenv.mkDerivation rec {
  pname = "0ad";
  version = "0.0.24b";

  src = fetchurl {
   url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-build.tar.xz";
   sha256 = "1a1py45hkh2cswi09vbf9chikgxdv9xplsmg6sv6xhdznv4j6p1j";
  };

  #this is required so SpiderMonkey builds with (cargo-link is searching impure paths)
  NIX_ENFORCE_PURITY=0;

  nativeBuildInputs = [
   autoconf213
   cargo
   llvmPackages.llvm
   llvmPackages.libcxx
   llvmPackages.libcxxStdenv
   llvmPackages.libclang
   python3
   perl
   pkg-config
   rust-cbindgen
   which
   yasm
   zip
  ];

  patches = [
    ./rootdir_env.patch
  ];

  depsBuildBuild = [buildPackages.stdenv.cc];

  buildInputs = [
   readline
   cargo-c
   boost
   icu67
   libxml2
   libpng
   libjpeg
   zlib
   curl
   libogg
   libvorbis
   enet
   miniupnpc
   openal
   libGLU
   libGL
   xorgproto
   libX11
   libXcursor
   nspr
   SDL2
   gloox
   nvidia-texture-tools
   libsodium
   fmt
   libidn
   cargo
   rustc
   python3
   yasm
   nspr] ++ lib.optional withEditor wxGTK;

  NIX_CFLAGS_COMPILE = toString [
    "-I${xorgproto}/include/X11"
    "-I${libX11.dev}/include/X11"
    "-I${libXcursor.dev}/include/X11"
    "-I${SDL2}/include/SDL2"
  ];

  configurePhase = ''
    # Delete shipped libraries which we don't need.
    rm -rf libraries/source/{enet,miniupnpc,nvtt}
    # Workaround invalid pkg-config name for mozjs
    mkdir pkg-config
    PKG_CONFIG_PATH="$PWD/pkg-config:$PKG_CONFIG_PATH"
    # bash doesn't know die anymore
    find -name build.sh -exec sed -i -e "s/die \(.*\)/(echo \1;exit 1)/g" {} \;
    # Update Makefiles
    pushd build/workspaces
    ./update-workspaces.sh \
      --with-system-nvtt \
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

  meta = with lib; {
    description = "A free, open-source game of ancient warfare";
    homepage = "https://play0ad.com/";
    license = with licenses; [
      gpl2 lgpl21 mit cc-by-sa-30
      licenses.zlib # otherwise masked by pkgs.zlib
    ];
    platforms = subtractLists platforms.i686 platforms.linux;
  };
}
