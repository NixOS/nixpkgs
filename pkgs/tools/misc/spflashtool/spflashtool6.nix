{
  lib,
  stdenv,
  callPackage,
  autoPatchelfHook,
  python3,
  qt5,
  udevCheckHook,
  copyDesktopItems,
}:
let
  common = callPackage ./common.nix { };

  major = "6";
  minor = "2228";

  optionIni = common.mkOptionIni "spflashtool6-option.ini" {
    Trace = {
      DALogLevel = "INFO";
      DALogChannel = "UART";
    };
    Conn.BaudRate = 3;
    Download.BootToFastMode = false;
    ModemManager.CheckKernelVersion = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "spflashtool${major}";
  version = "${major}.${minor}";

  src = common.mkSrc {
    inherit (finalAttrs) version;
    hash = "sha256-UDLHA9MATJwMJ91/yqUnsC0+lhZNNsL5E/baT2YotTg=";
  };

  desktopItem = common.mkDesktopItem major;
  desktopItems = [ finalAttrs.desktopItem ];

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
    copyDesktopItems
    (python3.withPackages (ps: [ ps.r2pipe ]))
    udevCheckHook
  ];

  strictDeps = true;
  __structuredAttrs = true;

  doInstallCheck = true;

  buildInputs = with qt5; [
    qtbase
    qtserialport
    qtxmlpatterns
  ];

  dontUnpack = true;
  dontBuild = true;

  qtWrapperArgs =
    let
      runtimeLibs = with qt5; [
        qtbase
        qtserialport
        qtxmlpatterns
      ];
    in
    [
      "--set"
      "LD_LIBRARY_PATH"
      (lib.makeLibraryPath runtimeLibs)
    ];

  installPhase = ''
    runHook preInstall

    install -Dm0644 $src/{libflash,libimagechecker}.1.0.0.so $src/libsla_challenge.so -t $out/lib/
    install -Dm0755 $src/SPFlashToolV6 $out/bin/spflashtool6

    python3 ${./r2patch.py} ${./spflashtool6-patches.py} $out/bin

    install -Dm0644 $src/console_mode.xsd $src/readback_ui_bak.xsd -t $out/bin/
    install -Dm0644 ${optionIni} $out/bin/option.ini
    install -Dm0644 $src/99-ttyacms.rules \
      $out/lib/udev/rules.d/99-ttyacms.rules

    install -Dm0644 ${./spflashtool6.png} \
      $out/share/icons/hicolor/256x256/apps/spflashtool6.png

    runHook postInstall
  '';

  meta = common.mkMeta { inherit major minor; };
})
