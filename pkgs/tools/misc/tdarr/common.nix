{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  ffmpeg,
  handbrake,
  mkvtoolnix,
  ccextractor,
  gtk3,
  libayatana-appindicator,
  wayland,
  libxkbcommon,
  mesa,
  libxcb,
  leptonica,
  glib,
  gobject-introspection,
  libx11,
  libxcursor,
  libxfixes,
  tesseract4,
  perl,
}:
{
  pname,
  component, # "server" or "node"
  hashes,
  includeInPath ? [ ], # Additional packages to include in PATH
  installIcons ? false, # Whether to install icon files
  passthru ? { }, # Additional passthru attributes
}:
let
  platform =
    {
      x86_64-linux = "linux_x64";
      aarch64-linux = "linux_arm64";
      x86_64-darwin = "darwin_x64";
      aarch64-darwin = "darwin_arm64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  componentUpper =
    lib.toUpper (builtins.substring 0 1 component)
    + builtins.substring 1 (builtins.stringLength component) component;
  componentName = "Tdarr_${componentUpper}";
  componentTrayName = "${componentName}_Tray";

  binPath = lib.makeBinPath (
    [
      ffmpeg
      mkvtoolnix
    ]
    ++ includeInPath
    # ! Handbrake is currently marked as broken on darwin
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) handbrake
  );

  commonWrapperArgs = lib.escapeShellArgs (
    [
      "--prefix"
      "PATH"
      ":"
      binPath
      "--run"
      "export rootDataPath=\${rootDataPath:-\${XDG_DATA_HOME:-$HOME/.local/share}/tdarr/${component}}; mkdir -p \"$rootDataPath\"/configs \"$rootDataPath\"/logs; cd \"$rootDataPath\""
    ]
    ++ lib.optionals (component == "node") [
      "--run"
      "mkdir -p \"$rootDataPath\"/assets/app/plugins"
    ]
    ++ [
      "--run"
      ''_cfg="$rootDataPath/configs/${componentName}_Config.json"; if [ -f "$_cfg" ]; then grep -q ffprobePath "$_cfg" || sed -i '1s/{/{"ffprobePath":"",/' "$_cfg"; else printf '{"ffprobePath":""}' > "$_cfg"; fi''
      "--set-default"
      "ffmpegPath"
      "${ffmpeg}/bin/ffmpeg"
      "--set-default"
      "ffprobePath"
      "${ffmpeg}/bin/ffprobe"
      "--set-default"
      "mkvpropeditPath"
      "${mkvtoolnix}/bin/mkvpropedit"
    ]
    ++ lib.optionals (component == "server") [
      "--set-default"
      "ccextractorPath"
      "${ccextractor}/bin/ccextractor"
    ]
    # ! Handbrake is currently marked as broken on darwin
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      "--set-default"
      "handbrakePath"
      "${handbrake}/bin/HandBrakeCLI"
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "2.58.02";

  src = fetchzip {
    url = "https://storage.tdarr.io/versions/${finalAttrs.version}/${platform}/${componentName}.zip";
    sha256 = hashes.${platform} or (throw "Unsupported platform: ${platform}");
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    gtk3
    libayatana-appindicator
    wayland
    libxkbcommon
    libxcb
    mesa
    tesseract4
    leptonica
    glib
    gobject-introspection
    libx11
    libxcursor
    libxfixes
  ];

  postPatch = ''
    rm -rf ./assets/app/ffmpeg
    rm -rf ./assets/app/ccextractor

    substituteInPlace node_modules/exiftool-vendored.pl/bin/exiftool \
      --replace-fail "#!/usr/bin/perl" "#!${perl}/bin/perl"

    # * exiftool-vendored checks for /usr/bin/perl existence; when missing (NixOS), it sets ignoreShebang=true which breaks spawn by using shell:true with an env lacking PATH. Since we patched the shebang, force ignoreShebang to false.
    substituteInPlace node_modules/exiftool-vendored/dist/ExifTool.js \
      --replace-fail '!_fs.existsSync("/usr/bin/perl")' 'false'
  '';

  preInstall = ''
    mkdir -p $out/{bin,share/${pname}}
  '';

  installPhase = ''
    runHook preInstall

    # Copy contents (source is already unpacked)
    cp -r . $out/share/${pname}/

    chmod +x $out/share/${pname}/${componentName}

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper $out/share/${pname}/${componentName} $out/bin/${pname} ${commonWrapperArgs}
  ''
  # TODO: Check on each update to see if the Tdarr_Node_tray gets re-added to the aarch64-linux build. Reach out to upstream?
  + lib.optionalString (stdenv.hostPlatform.system != "aarch64-linux") ''
    makeWrapper $out/share/${pname}/${componentTrayName} $out/bin/${pname}-tray ${commonWrapperArgs}
  ''
  + lib.optionalString installIcons ''

    # Install icons from the copied source files
    for size in 192 512; do
      if [ -f $out/share/${pname}/public/logo''${size}.png ]; then
        install -Dm644 $out/share/${pname}/public/logo''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
      fi
    done
  ''
  + "";

  desktopItems = lib.optionals (stdenv.isLinux && stdenv.hostPlatform.system != "aarch64-linux") [
    (makeDesktopItem {
      desktopName = "Tdarr ${componentUpper} Tray";
      name = "Tdarr ${componentUpper} Tray";
      exec = "${pname}-tray";
      terminal = false;
      type = "Application";
      icon = if installIcons then pname else "";
      categories = [ "Utility" ];
    })
  ];

  passthru = {
    updateScript = {
      command = [ ./update-hashes.sh ];
      supportedFeatures = [ "commit" ];
    };
  }
  // passthru;

  meta = {
    description = "Distributed transcode automation ${component} using FFmpeg/HandBrake";
    homepage = "https://tdarr.io";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ mistyttm ];
    mainProgram = pname;
  };
})
