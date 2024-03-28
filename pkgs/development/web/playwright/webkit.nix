{ stdenv
, fetchzip
, fetchFromGitHub
, makeWrapper
, autoPatchelfHook
, patchelfUnstable

, at-spi2-atk
, cairo
, flite
, fontconfig
, freetype
, glib
, glib-networking
, gst_all_1
, harfbuzz
, harfbuzzFull
, icu70
, lcms
, libdrm
, libepoxy
, libevent
, libgcc
, libgcrypt
, libgpg-error
, libjpeg8
, libopus
, libpng
, libsoup_3
, libtasn1
, libvpx
, libwebp
, libwpe
, libwpe-fdo
, libxkbcommon
, libxml2
, libxslt
, mesa
, sqlite
, systemdLibs
, wayland-scanner
, woff2
, zlib

, suffix
, revision
}:
let
  suffix' = if suffix == "linux"
            then "ubuntu-22.04"
            else suffix;

  libvpx' = libvpx.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.12.0";
    src = fetchFromGitHub {
      owner = "webmproject";
      repo = previousAttrs.pname;
      rev = "v${finalAttrs.version}";
      sha256 = "sha256-9SFFE2GfYYMgxp1dpmL3STTU2ea1R5vFKA1L0pZwIvQ=";
    };
  });

in
stdenv.mkDerivation {
  name = "webkit";
  src = fetchzip {
    url = "https://playwright.azureedge.net/builds/webkit/${revision}/webkit-${suffix'}.zip";
    hash = "sha256-w+9Jf9nH+T3VPCzHopt5dPhwcRm6PLJ5fVM0w725Pjw=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook patchelfUnstable makeWrapper];
  buildInputs = [
    at-spi2-atk
    cairo
    flite
    fontconfig.lib
    freetype
    glib
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    harfbuzz
    harfbuzzFull
    icu70
    lcms
    libdrm
    libepoxy
    libevent
    libgcc.lib
    libgcrypt
    libgpg-error
    libjpeg8
    libopus
    libpng
    libsoup_3
    libtasn1
    libwebp
    libwpe
    libwpe-fdo
    libvpx'
    libxml2
    libxslt
    mesa
    sqlite
    systemdLibs
    wayland-scanner
    woff2.lib
    libxkbcommon
    zlib
  ];

  patchelfFlags = [ "--no-clobber-old-sections"];
  buildPhase = ''
    cp -R . $out

    # remove unused gtk browser
    rm -rf $out/minibrowser-gtk

    wrapProgram $out/minibrowser-wpe/bin/MiniBrowser \
      --prefix GIO_EXTRA_MODULES ":" "${glib-networking}/lib/gio/modules/:$GIO_EXTRA_MODULES}" \
  '';
}
