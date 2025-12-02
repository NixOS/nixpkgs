{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  makeWrapper,
  autoPatchelfHook,
  patchelfUnstable,
  fetchpatch,
  libjxl,
  brotli,
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
  libavif,
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
  libavif' = libavif.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.9.3";
      src = fetchFromGitHub {
        owner = "AOMediaCodec";
        repo = finalAttrs.pname;
        rev = "v${finalAttrs.version}";
        hash = "sha256-ME/mkaHhFeHajTbc7zhg9vtf/8XgkgSRu9I/mlQXnds=";
      };
      postPatch = "";
      patches = [ ];
    }
  );

  libjxl' = libjxl.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.8.2";
      src = fetchFromGitHub {
        owner = "libjxl";
        repo = "libjxl";
        rev = "v${finalAttrs.version}";
        hash = "sha256-I3PGgh0XqRkCFz7lUZ3Q4eU0+0GwaQcVb6t4Pru1kKo=";
        fetchSubmodules = true;
      };
      patches = [
        # Add missing <atomic> content to fix gcc compilation for RISCV architecture
        # https://github.com/libjxl/libjxl/pull/2211
        (fetchpatch {
          url = "https://github.com/libjxl/libjxl/commit/22d12d74e7bc56b09cfb1973aa89ec8d714fa3fc.patch";
          hash = "sha256-X4fbYTMS+kHfZRbeGzSdBW5jQKw8UN44FEyFRUtw0qo=";
        })
      ];
      postPatch = ''
        # Fix multiple definition errors by using C++17 instead of C++11
        substituteInPlace CMakeLists.txt \
          --replace "set(CMAKE_CXX_STANDARD 11)" "set(CMAKE_CXX_STANDARD 17)"
        # Fix the build with CMake 4.
        # See:
        # * <https://github.com/webmproject/sjpeg/commit/9990bdceb22612a62f1492462ef7423f48154072>
        # * <https://github.com/webmproject/sjpeg/commit/94e0df6d0f8b44228de5be0ff35efb9f946a13c9>
        substituteInPlace third_party/sjpeg/CMakeLists.txt \
          --replace-fail \
            'cmake_minimum_required(VERSION 2.8.7)' \
            'cmake_minimum_required(VERSION 3.5...3.10)'
      '';
      postInstall = "";

      cmakeFlags = [
        "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON"
        "-DJPEGXL_FORCE_SYSTEM_HWY=ON"
        "-DJPEGXL_FORCE_SYSTEM_GTEST=ON"
      ]
      ++ lib.optionals stdenv.hostPlatform.isStatic [
        "-DJPEGXL_STATIC=ON"
      ]
      ++ lib.optionals stdenv.hostPlatform.isAarch32 [
        "-DJPEGXL_FORCE_NEON=ON"
      ];
    }
  );
  webkit-linux = stdenv.mkDerivation {
    name = "playwright-webkit";
    src = fetchzip {
      url = "https://playwright.azureedge.net/builds/webkit/${revision}/webkit-${suffix'}.zip";
      stripRoot = false;
      hash =
        {
          x86_64-linux = "sha256-OSVHFGdcQrzmhLPdXF61tKmip/6/D+uaQgSBBQiOIZI=";
          aarch64-linux = "sha256-b8XwVMCwSbujyqgkJKIPAVNX83Qmmsthprr2x9XSb10=";
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
      brotli
      libjxl'
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      harfbuzz
      harfbuzzFull
      icu70
      lcms
      libavif'
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
      # remove bundled libs
      rm -rf $out/minibrowser-wpe/sys

      # TODO: still fails on ubuntu trying to find libEGL_mesa.so.0
      wrapProgram $out/minibrowser-wpe/bin/MiniBrowser \
        --prefix GIO_EXTRA_MODULES ":" "${glib-networking}/lib/gio/modules/" \
        --prefix LD_LIBRARY_PATH ":" $out/minibrowser-wpe/lib

    '';

    preFixup = ''
      # Fix libxml2 breakage. See https://github.com/NixOS/nixpkgs/pull/396195#issuecomment-2881757108
      mkdir -p "$out/lib"
      ln -s "${lib.getLib libxml2}/lib/libxml2.so" "$out/lib/libxml2.so.2"
    '';
  };
  webkit-darwin = fetchzip {
    url = "https://playwright.azureedge.net/builds/webkit/${revision}/webkit-${suffix'}.zip";
    stripRoot = false;
    hash =
      {
        x86_64-darwin = "sha256-shjhozJS2VbBjpjJVlM9hwBzGWwgva1qhfEUhY8t9Bk=";
        aarch64-darwin = "sha256-ZRl86L/OOTNPWfZDl6JQfuXL41kI/Wir99/JIbf7T7M=";
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
