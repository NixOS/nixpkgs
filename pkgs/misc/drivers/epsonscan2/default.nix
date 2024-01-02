{ lib
, stdenv
, autoPatchelfHook
, boost
, cmake
, copyDesktopItems
, imagemagick
, fetchpatch
, fetchzip
, killall
, libjpeg
, libpng
, libtiff
, libtool
, libusb1
, makeDesktopItem
, qtbase
, wrapQtAppsHook

, withGui ? true
, withNonFreePlugins ? false
}:

let
  pname = "epsonscan2";
  description = "Epson Scan 2 scanner driver for many modern Epson scanners and multifunction printers";
  version = "6.7.61.0";

  system = stdenv.hostPlatform.system;

  src = fetchzip {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/14/53/67/1a6447b4acc5568dfd970feba0518fabea35bca2/epsonscan2-${version}-1.src.tar.gz";
    hash = "sha256-xwvdgmV6Mrs1RC18U2mA+HlTYybeYb0V5lz5hCvC7+8=";
  };
  bundle = {
    "i686-linux" = fetchzip {
      name = "${pname}-bundle";
      url = "https://download3.ebz.epson.net/dsc/f/03/00/14/53/69/3151031c0fb4deea3f48781fd051411b983ccee4/epsonscan2-bundle-${version}.i686.deb.tar.gz";
      hash = "sha256-nq3Nqunt8aMcCf7U7JBYrVscvrhhcwcn8RlhYXLmC2c=";
    };

    "x86_64-linux" = fetchzip {
      name = "${pname}-bundle";
      url = "https://download3.ebz.epson.net/dsc/f/03/00/14/53/68/a5e06101ba3f328dd747888e3dddebbb677bb8c8/epsonscan2-bundle-${version}.x86_64.deb.tar.gz";
      hash = "sha256-cFx54CKkZtvhZ5ABuBwB8+IzhT2lu8D3+GZFaMuWf3Y=";
    };
  }."${system}" or (throw "Unsupported system: ${system}");

in
stdenv.mkDerivation {
  inherit pname src version;

  patches = [
    ./build.patch
    (fetchpatch {
      url = "https://github.com/flathub/net.epson.epsonscan2/raw/master/patches/epsonscan2-crash.patch";
      hash = "sha256-srMxlFfnZuJ3ed5veFcJIiZuW27F/3xOS0yr4ywn4FI=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/flathub/net.epson.epsonscan2/master/patches/epsonscan2-oob-container.patch";
      hash = "sha256-FhXZT0bIBYwdFow2USRJl8Q7j2eqpq98Hh0lHFQlUQY=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/flathub/net.epson.epsonscan2/master/patches/epsonscan2-xdg-open.patch";
      hash = "sha256-4ih3vZjPwWiiAxKfpLIwbbsk1K2oXSuxGbT5PVwfUsc=";
    })
  ];

  postPatch = ''
    substituteInPlace src/Controller/Src/Scanner/Engine.cpp \
      --replace '@KILLALL@' ${killall}/bin/killall

    substituteInPlace src/Controller/Src/Filter/GetOrientation.cpp \
      --replace '@OCR_ENGINE_GETROTATE@' $out/libexec/epsonscan2-ocr/ocr-engine-getrotate
  '';

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals withGui [
    imagemagick # to make icons
    wrapQtAppsHook
  ] ++ lib.optionals withNonFreePlugins [
    autoPatchelfHook
  ];

  buildInputs = [
    boost
    libjpeg
    libpng
    libtiff
    libusb1
  ] ++ lib.optionals withGui [
    copyDesktopItems
    qtbase
  ] ++ lib.optionals withNonFreePlugins [
    libtool.lib
  ];

  cmakeFlags = [
    # The non-free (Debian) packages uses this directory structure so do the same when compiling
    # from source so we can easily merge them.
    "-DCMAKE_INSTALL_LIBDIR=lib/${system}-gnu"
  ] ++ lib.optionals (!withGui) [
    "-DNO_GUI=ON"
  ];

  postInstall = ''
    # But when we put all the libraries in lib/${system}-gnu, then SANE can't find the
    # required libraries so create a symlink to where it expects them to be.
    mkdir -p $out/lib/sane
    for file in $out/lib/${system}-gnu/sane/*.so.*; do
      ln -s $file $out/lib/sane/
    done
  '' + lib.optionalString withGui ''
    # The icon file extension is .ico but it's actually a png!
    mkdir -p $out/share/icons/hicolor/{48x48,128x128}/apps
    convert $src/Resources/Icons/escan2_app.ico -resize 48x48 $out/share/icons/hicolor/48x48/apps/epsonscan2.png
    convert $src/Resources/Icons/escan2_app.ico -resize 128x128 $out/share/icons/hicolor/128x128/apps/epsonscan2.png
  '' + lib.optionalString withNonFreePlugins ''
    ar xf ${bundle}/plugins/epsonscan2-non-free-plugin_*.deb
    tar Jxf data.tar.xz
    cp -r usr/* $out
  '';

  desktopItems = lib.optionals withGui [
    (makeDesktopItem {
      name = pname;
      exec = "epsonscan2";
      icon = "epsonscan2";
      desktopName = "Epson Scan 2";
      genericName = "Epson Scan 2";
      comment = description;
      categories = [ "Graphics" "Scanning" ];
    })
  ];

  meta = {
    inherit description;
    longDescription = ''
      Epson Scan 2 scanner driver including optional non-free plugins such as OCR and network
      scanning.

      To use the SANE backend:
      <literal>
      hardware.sane.extraBackends = [ pkgs.epsonscan2 ];
      </literal>

      Overrides can be used to customise this package. For example, to enable non-free plugins and
      disable the Epson GUI:
      <literal>
      pkgs.epsonscan2.override { withNonFreePlugins = true; withGui = false; }
      </literal>
    '';
    homepage = "https://support.epson.net/linux/en/epsonscan2.php";
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ] ++ lib.optionals withNonFreePlugins [ binaryNativeCode ];
    license = with lib.licenses; if withNonFreePlugins then unfree else lgpl21Plus;
    maintainers = with lib.maintainers; [ james-atkins ];
  };
}

