{
  lib,
  stdenv,
  autoPatchelfHook,
  boost,
  cmake,
  copyDesktopItems,
  imagemagick,
  fetchpatch,
  fetchzip,
  killall,
  libjpeg,
  libpng,
  libtiff,
  libtool,
  libusb1,
  makeDesktopItem,
  qtbase,
  wrapQtAppsHook,

  withGui ? true,
  withNonFreePlugins ? false,
}:

let
  pname = "epsonscan2";
  description = "Epson Scan 2 scanner driver for many modern Epson scanners and multifunction printers";
  version = "6.7.63.0";

  system = stdenv.hostPlatform.system;

  src = fetchzip {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/15/17/69/0ef02802c476a6564f13cac929859c394f40326a/epsonscan2-6.7.63.0-1.src.tar.gz";
    hash = "sha256-ZLnbIk0I7g6ext5anPD+/lD4qNlk6f2fL0xdIWLcfbY=";
  };
  bundle =
    {
      "i686-linux" = fetchzip {
        name = "${pname}-bundle";
        url = "https://download3.ebz.epson.net/dsc/f/03/00/15/17/67/ceae6a02aaa81cb61012899987fbb5ab891b6ab2/epsonscan2-bundle-6.7.63.0.i686.deb.tar.gz";
        hash = "sha256-h9beAzNdjOhTlZqW0rJbSQXGOpvFRGvTcWw0ZtOqiYY=";
      };

      "x86_64-linux" = fetchzip {
        name = "${pname}-bundle";
        url = "https://download3.ebz.epson.net/dsc/f/03/00/15/17/68/050e5a55ed90f4efb4ca3bdd34e5797b149443ca/epsonscan2-bundle-6.7.63.0.x86_64.deb.tar.gz";
        hash = "sha256-+S17FfS2h4zZCvE6W+yZvdJb6+OWYTt0ZWCA+pe1NZc=";
      };
    }
    ."${system}" or (throw "Unsupported system: ${system}");

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

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals withGui [
      imagemagick # to make icons
      wrapQtAppsHook
    ]
    ++ lib.optionals withNonFreePlugins [
      autoPatchelfHook
    ];

  buildInputs =
    [
      boost
      libjpeg
      libpng
      libtiff
      libusb1
    ]
    ++ lib.optionals withGui [
      copyDesktopItems
      qtbase
    ]
    ++ lib.optionals withNonFreePlugins [
      libtool.lib
    ];

  cmakeFlags =
    [
      # The non-free (Debian) packages uses this directory structure so do the same when compiling
      # from source so we can easily merge them.
      "-DCMAKE_INSTALL_LIBDIR=lib/${system}-gnu"
    ]
    ++ lib.optionals (!withGui) [
      "-DNO_GUI=ON"
    ];

  postInstall =
    ''
      # But when we put all the libraries in lib/${system}-gnu, then SANE can't find the
      # required libraries so create a symlink to where it expects them to be.
      mkdir -p $out/lib/sane
      for file in $out/lib/${system}-gnu/sane/*.so.*; do
        ln -s $file $out/lib/sane/
      done
    ''
    + lib.optionalString withGui ''
      # The icon file extension is .ico but it's actually a png!
      mkdir -p $out/share/icons/hicolor/{48x48,128x128}/apps
      convert $src/Resources/Icons/escan2_app.ico -resize 48x48 $out/share/icons/hicolor/48x48/apps/epsonscan2.png
      convert $src/Resources/Icons/escan2_app.ico -resize 128x128 $out/share/icons/hicolor/128x128/apps/epsonscan2.png
    ''
    + lib.optionalString withNonFreePlugins ''
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
      categories = [
        "Graphics"
        "Scanning"
      ];
    })
  ];

  meta = {
    inherit description;
    mainProgram = "epsonscan2";
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
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance =
      with lib.sourceTypes;
      [ fromSource ] ++ lib.optionals withNonFreePlugins [ binaryNativeCode ];
    license = with lib.licenses; if withNonFreePlugins then unfree else lgpl21Plus;
    maintainers = with lib.maintainers; [ james-atkins ];
  };
}
