{ lib
,  stdenv
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
, system
, throwSystem
}:
let
  suffix' = if lib.hasPrefix "linux" suffix
            then "ubuntu-22.04" + (lib.removePrefix "linux" suffix)
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
    stripRoot = false;
    sha256 = {
      x86_64-linux = "0g1yp6yw6d2kgmwv4g5s35qp1y3lg6ds5irc7kakvyf7v5zlkvy3";
      aarch64-linux = "1jpy01msw5cl1www4s41g0mgjydl3frvmiy6dxgwq0qqf2zfz692";
    }.${system} or throwSystem;
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
