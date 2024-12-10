{
  lib,
  autoPatchelfHook,
  cpio,
  freetype,
  zlib,
  openssl,
  fetchurl,
  gcc-unwrapped,
  libjpeg8,
  libpng,
  fontconfig,
  stdenv,
  xar,
  xorg,
}:

let
  darwinAttrs = rec {
    version = "0.12.6-2";
    src = fetchurl {
      url = "https://github.com/wkhtmltopdf/packaging/releases/download/${version}/wkhtmltox-${version}.macos-cocoa.pkg";
      sha256 = "sha256-gaZrd7UI/t6NvKpnEnIDdIN2Vos2c6F/ZhG21R6YlPg=";
    };

    nativeBuildInputs = [
      xar
      cpio
    ];

    unpackPhase = ''
      xar -xf $src
      zcat Payload | cpio -i
      tar -xf usr/local/share/wkhtmltox-installer/wkhtmltox.tar.gz
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r bin include lib share $out/
      runHook postInstall
    '';
  };

  linuxAttrs = rec {
    version = "0.12.6-3";
    src = fetchurl {
      url = "https://github.com/wkhtmltopdf/packaging/releases/download/${version}/wkhtmltox-${version}.archlinux-x86_64.pkg.tar.xz";
      sha256 = "sha256-6Ewu8sPRbqvYWj27mBlQYpEN+mb+vKT46ljrdEUxckI=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      xorg.libXext
      xorg.libXrender

      freetype
      openssl
      zlib

      (lib.getLib fontconfig)
      (lib.getLib gcc-unwrapped)
      (lib.getLib libjpeg8)
      (lib.getLib libpng)
    ];

    unpackPhase = "tar -xf $src";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/bin usr/include usr/lib usr/share $out/
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation (
  {
    pname = "wkhtmltopdf-bin";

    dontStrip = true;

    doInstallCheck = true;

    installCheckPhase = ''
      $out/bin/wkhtmltopdf --version
    '';

    meta = with lib; {
      homepage = "https://wkhtmltopdf.org/";
      description = "Tools for rendering web pages to PDF or images (binary package)";
      longDescription = ''
        wkhtmltopdf and wkhtmltoimage are open source (LGPL) command line tools
        to render HTML into PDF and various image formats using the QT Webkit
        rendering engine. These run entirely "headless" and do not require a
        display or display service.

        There is also a C library, if you're into that kind of thing.
      '';
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [
        nbr
        kalbasit
      ];
      platforms = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) darwinAttrs
  // lib.optionalAttrs (stdenv.hostPlatform.isLinux) linuxAttrs
)
