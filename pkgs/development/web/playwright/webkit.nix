{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  makeWrapper,
  autoPatchelfHook,
  patchelfUnstable,

  at-spi2-atk,
  cairo,
  flite,
  fontconfig,
  freetype,
  glib,
  glib-networking,
  gst_all_1,
  harfbuzz,
  harfbuzzFull,
  icu70,
  lcms,
  libdrm,
  libepoxy,
  libevent,
  libgcc,
  libgcrypt,
  libgpg-error,
  libjpeg8,
  libopus,
  libpng,
  libsoup_3,
  libtasn1,
  libvpx,
  libwebp,
  libwpe,
  libwpe-fdo,
  libxkbcommon,
  libxml2,
  libxslt,
  libgbm,
  sqlite,
  systemdLibs,
  wayland-scanner,
  woff2,
  zlib,
  suffix,
  revision,
  system,
  throwSystem,
}:
let
  suffix' =
    if lib.hasPrefix "linux" suffix then
      "ubuntu-22.04" + (lib.removePrefix "linux" suffix)
    else if lib.hasPrefix "mac" suffix then
      "mac-14" + (lib.removePrefix "mac" suffix)
    else
      suffix;
  libvpx' = libvpx.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.12.0";
      src = fetchFromGitHub {
        owner = "webmproject";
        repo = finalAttrs.pname;
        rev = "v${finalAttrs.version}";
        sha256 = "sha256-9SFFE2GfYYMgxp1dpmL3STTU2ea1R5vFKA1L0pZwIvQ=";
      };
    }
  );
  webkit-linux = stdenv.mkDerivation {
    name = "playwright-webkit";
    src = fetchzip {
      url = "https://playwright.azureedge.net/builds/webkit/${revision}/webkit-${suffix'}.zip";
      stripRoot = false;
      hash =
        {
          x86_64-linux = "sha256-vz/c2Bzr1NWRZZL5hIRwnor2Wte61gS++8rRfmy9T+0=";
          aarch64-linux = "sha256-dS4Hsy/lGZWgznviwkslSk5oBYdUIBxeQPfaEyLNXyc=";
        }
        .${system} or throwSystem;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      patchelfUnstable
      makeWrapper
    ];
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
      libgbm
      sqlite
      systemdLibs
      wayland-scanner
      woff2.lib
      libxkbcommon
      zlib
    ];

    patchelfFlags = [ "--no-clobber-old-sections" ];
    buildPhase = ''
      cp -R . $out

      # remove unused gtk browser
      rm -rf $out/minibrowser-gtk

      wrapProgram $out/minibrowser-wpe/bin/MiniBrowser \
        --prefix GIO_EXTRA_MODULES ":" "${glib-networking}/lib/gio/modules/"
    '';
  };
  webkit-darwin = fetchzip {
    url = "https://playwright.azureedge.net/builds/webkit/${revision}/webkit-${suffix'}.zip";
    stripRoot = false;
    hash =
      {
        x86_64-darwin = "sha256-lOAHJaDXtt80RhqFNaO1JhaJH5WAu6+rpoR+IsfzGeM=";
        aarch64-darwin = "sha256-GrjTnMGTPBdRI3xE5t9HbXLrvgOjCdqbJGElTKhUoA4=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = webkit-linux;
  aarch64-linux = webkit-linux;
  x86_64-darwin = webkit-darwin;
  aarch64-darwin = webkit-darwin;
}
.${system} or throwSystem
