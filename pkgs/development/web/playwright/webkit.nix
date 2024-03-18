{ stdenv
, fetchzip
, fetchFromGitHub
, wrapGAppsHook
, autoPatchelfHook
, patchelfUnstable
, at-spi2-atk
, libgcc
, cairo
, enchant
, libepoxy
, libevent
, flite
, fontconfig
, freetype
, mesa
, libglvnd
, libgcrypt
, gtk3
, gdk-pixbuf
, glib
, libgpg-error
, gst_all_1
, harfbuzzFull
, harfbuzz
, hyphen
, icu70
, libjpeg8
, lcms
, libmanette
, openjpeg
, libopus
, pango
, libpng
, libsecret
, libsoup_3
, sqlite
, systemdLibs
, libtasn1
, libwebp
, rigsofrods-bin
, woff2
, xorg
, libxml2
, libxslt
, libvpx
, zlib
, suffix
, revision
}:
let
  suffix' = if suffix == "linux"
            then "ubuntu-22.04"
            else suffix;

  libvpx_1_12 = libvpx.overrideAttrs (finalAttrs: previousAttrs: {
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

  nativeBuildInputs = [ wrapGAppsHook autoPatchelfHook patchelfUnstable];
  buildInputs = [
    at-spi2-atk
    libgcc.lib
    cairo
    enchant
    libepoxy
    libevent
    flite
    fontconfig.lib
    freetype
    libglvnd
    mesa
    libgcrypt
    gtk3
    gdk-pixbuf
    glib
    libgpg-error
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    harfbuzzFull
    harfbuzz
    hyphen
    icu70
    libjpeg8

    lcms
    libmanette

    openjpeg
    libopus
    pango
    libpng
    libsecret
    libsoup_3
    sqlite
    systemdLibs
    libtasn1
    libwebp
    rigsofrods-bin
    woff2.lib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    libxml2
    xorg.libXrender
    libxslt
    zlib
    libvpx_1_12
  ];


  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections"];
  buildPhase = ''
    cp -R . $out
  '';
}
