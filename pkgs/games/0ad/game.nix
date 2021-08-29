{ stdenv, lib, perl, fetchurl, python2, fmt, libidn
, pkg-config, spidermonkey_78, boost, icu, libxml2, libpng, libsodium
, libjpeg, zlib, curl, libogg, libvorbis, enet, miniupnpc
, openal, libGLU, libGL, xorgproto, libX11, libXcursor, nspr, SDL2
, gloox, nvidia-texture-tools
, withEditor ? true, wxGTK
}:

# You can find more instructions on how to build 0ad here:
#    https://trac.wildfiregames.com/wiki/BuildInstructions

let
  # the game requires a special version 78.6.0 of spidermonkey, otherwise
  # we get compilation errors. We override the src attribute of spidermonkey_78
  # in order to reuse that declartion, while giving it a different source input.
  spidermonkey_78_6 = spidermonkey_78.overrideAttrs(old: rec {
    version = "78.6.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
      sha256 = "0lyg65v380j8i2lrylwz8a5ya80822l8vcnlx3dfqpd3s6zzjsay";
    };
    patches = (old.patches or []) ++ [
      ./spidermonkey-cargo-toml.patch
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "0ad";
  version = "0.0.24b";

  src = fetchurl {
    url = "http://releases.wildfiregames.com/0ad-${version}-alpha-unix-build.tar.xz";
    sha256 = "1a1py45hkh2cswi09vbf9chikgxdv9xplsmg6sv6xhdznv4j6p1j";
  };

  nativeBuildInputs = [ python2 perl pkg-config ];

  buildInputs = [
    spidermonkey_78_6 boost icu libxml2 libpng libjpeg
    zlib curl libogg libvorbis enet miniupnpc openal libidn
    libGLU libGL xorgproto libX11 libXcursor nspr SDL2 gloox
    nvidia-texture-tools libsodium fmt
  ] ++ lib.optional withEditor wxGTK;

  NIX_CFLAGS_COMPILE = toString [
    "-I${xorgproto}/include/X11"
    "-I${libX11.dev}/include/X11"
    "-I${libXcursor.dev}/include/X11"
    "-I${SDL2}/include/SDL2"
    "-I${fmt.dev}/include"
  ];

  patches = [ ./rootdir_env.patch ];

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
    maintainers = with maintainers; [ chvp ];
    platforms = subtractLists platforms.i686 platforms.linux;
  };
}
