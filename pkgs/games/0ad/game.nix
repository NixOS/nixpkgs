{
  stdenv,
  lib,
  fetchpatch,
  fetchpatch2,
  perl,
  fetchurl,
  python3,
  fmt,
  libidn,
  pkg-config,
  spidermonkey_78,
  boost,
  icu,
  libxml2,
  libpng,
  libsodium,
  libjpeg,
  zlib,
  curl,
  libogg,
  libvorbis,
  enet,
  miniupnpc,
  openal,
  libGLU,
  libGL,
  xorgproto,
  libX11,
  libXcursor,
  nspr,
  SDL2,
  gloox,
  nvidia-texture-tools,
  freetype,
  withEditor ? true,
  wxGTK,
}:

# You can find more instructions on how to build 0ad here:
#    https://trac.wildfiregames.com/wiki/BuildInstructions

let
  # the game requires a special version 78.6.0 of spidermonkey, otherwise
  # we get compilation errors. We override the src attribute of spidermonkey_78
  # in order to reuse that declartion, while giving it a different source input.
  spidermonkey_78_6 = spidermonkey_78.overrideAttrs (old: rec {
    version = "78.6.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
      sha256 = "0lyg65v380j8i2lrylwz8a5ya80822l8vcnlx3dfqpd3s6zzjsay";
    };
    patches = (old.patches or [ ]) ++ [
      ./spidermonkey-cargo-toml.patch
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "0ad";
  version = "0.0.26";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-build.tar.xz";
    sha256 = "Lhxt9+MxLnfF+CeIZkz/w6eNO/YGBsAAOSdeHRPA7ks=";
  };

  nativeBuildInputs = [
    python3
    perl
    pkg-config
  ];

  buildInputs = [
    spidermonkey_78_6
    boost
    icu
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
    libidn
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
    freetype
  ] ++ lib.optional withEditor wxGTK;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${xorgproto}/include"
    "-I${libX11.dev}/include"
    "-I${libXcursor.dev}/include"
    "-I${SDL2}/include/SDL2"
    "-I${fmt.dev}/include"
    "-I${nvidia-texture-tools.dev}/include"
  ];

  NIX_CFLAGS_LINK = toString [
    "-L${nvidia-texture-tools.lib}/lib/static"
  ];

  patches = [
    ./rootdir_env.patch

    # Fix build with libxml v2.12
    # FIXME: Remove with next package update
    (fetchpatch {
      name = "libxml-2.12-fix.patch";
      url = "https://github.com/0ad/0ad/commit/d242631245edb66816ef9960bdb2c61b68e56cec.patch";
      hash = "sha256-Ik8ThkewB7wyTPTI7Y6k88SqpWUulXK698tevfSBr6I=";
    })
    # Fix build with GCC 13
    # FIXME: Remove with next package update
    (fetchpatch {
      name = "gcc-13-fix.patch";
      url = "https://github.com/0ad/0ad/commit/093e1eb23519ab4a4633a999a555a58e4fd5343e.patch";
      hash = "sha256-NuWO64narU1JID/F3cj7lJKjo96XR7gSW0w8I3/hhuw=";
    })
    # Fix build with miniupnpc 2.2.8
    # https://github.com/0ad/0ad/pull/45
    (fetchpatch2 {
      url = "https://github.com/0ad/0ad/commit/1575580bbc5278576693f3fbbb32de0b306aa27e.patch?full_index=1";
      hash = "sha256-iXiUYTJCWwJpb2U3P58jTV4OpyW6quofu8Jq6xNEq48=";
    })
  ];

  configurePhase = ''
    # Delete shipped libraries which we don't need.
    rm -rf libraries/source/{enet,miniupnpc,nvtt,spidermonkey}

    # Update Makefiles
    pushd build/workspaces
    ./update-workspaces.sh \
      --with-system-nvtt \
      --with-system-mozjs \
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
    install -D build/resources/0ad.png     $out/share/icons/hicolor/128x128/apps/0ad.png
    install -D build/resources/0ad.desktop $out/share/applications/0ad.desktop
  '';

  meta = with lib; {
    description = "Free, open-source game of ancient warfare";
    homepage = "https://play0ad.com/";
    license = with licenses; [
      gpl2Plus
      lgpl21
      mit
      cc-by-sa-30
      licenses.zlib # otherwise masked by pkgs.zlib
    ];
    maintainers = with maintainers; [ chvp ];
    platforms = subtractLists platforms.i686 platforms.linux;
    mainProgram = "0ad";
  };
}
