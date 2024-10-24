{
  stdenv,
  lib,
  newScope,
  fetchurl,
  undmg,
  copyDesktopItems,
  makeDesktopItem,

  writeShellScript,
  curl,
  jq,
  common-updater-scripts,

  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  dotnetCorePackages,
  extract-dotnet-resources,
  icoutils,

  libX11,
  libXrandr,
  libXext,
  libXi,
  libXcursor,
  libSM,
  libICE,
  gtk3,
  libGL,
  vulkan-loader,
}:
let
  jetBrainsPlatformMap = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linuxARM64";

    "x86_64-darwin" = "mac";
    "aarch64-darwin" = "macARM64";

    "i686-windows" = "windows";
    "x86_64-windows" = "windows64";
    "aarch64-windows" = "windowsARM64";
  };

  systemToJetBrainsPlatform =
    system: jetBrainsPlatformMap.${system} or (throw "Unsupported system: ${system}");

  # These are the same as dotnet rids for everything except macos, for some reason
  jetBrainsRuntimeIdentifierMap = {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
    "x86_64-darwin" = "macos-x64";
    "aarch64-darwin" = "macos-arm64";
    "x86_64-windows" = "win-x64";
    "aarch64-windows" = "win-arm64";
    "i686-windows" = "win-x86";
  };

  systemToJetBrainsRid =
    system: jetBrainsRuntimeIdentifierMap.${system} or (throw "unsupported platform ${system}");

  inherit (stdenv.hostPlatform) system;

  # A lot of these are loaded opportunistically, so provide all of them to be safe
  avaloniaDependencies = [
    # https://github.com/AvaloniaUI/Avalonia/blob/11.0.11/src/Avalonia.X11/XLib.cs
    libX11
    libXrandr
    libXext
    libXi
    libXcursor

    # https://github.com/AvaloniaUI/Avalonia/blob/11.0.11/src/Avalonia.X11/SMLib.cs
    libSM

    # https://github.com/AvaloniaUI/Avalonia/blob/11.0.11/src/Avalonia.X11/ICELib.cs
    libICE

    # https://github.com/AvaloniaUI/Avalonia/blob/11.0.11/src/Avalonia.X11/NativeDialogs/Gtk.cs
    gtk3

    # https://github.com/AvaloniaUI/Avalonia/blob/11.0.11/src/Avalonia.X11/Glx/Glx.cs#L50
    libGL

    # https://github.com/AvaloniaUI/Avalonia/blob/11.0.11/src/Avalonia.X11/Vulkan/VulkanSupport.cs#L15
    vulkan-loader
  ];

  mkJetBrainsAvaloniaProduct =
    {
      pname,
      version,
      desktopName,
      code,
      sources,
      dotnet-runtime ? dotnetCorePackages.runtime_8_0,
      iconHolder,
      executables ? [ desktopName ],
      meta,
    }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version;

      src = fetchurl (sources.${system} or (throw "Unsupported system: ${system}"));

      nativeBuildInputs =
        lib.optionals stdenv.hostPlatform.isLinux [
          autoPatchelfHook
          makeWrapper
          wrapGAppsHook3
          copyDesktopItems
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ undmg ];

      buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ dotnet-runtime ];

      dontFixup = stdenv.hostPlatform.isDarwin;

      postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
        # Remove the embedded dotnet runtime so we can use our own
        rm -rf ${systemToJetBrainsRid system}/dotnet
      '';

      installPhase =
        ''
          runHook preInstall
        ''
        + (
          if stdenv.hostPlatform.isDarwin then
            ''
              mkdir -p "$out/Applications/${desktopName}.app"
              cp -r ./* "$out/Applications/${desktopName}.app"

              mkdir -p "$out/bin"
              ${lib.concatMapStringsSep "\n" (executable: ''
                ln -s "$out/Applications/${desktopName}.app/Contents/DotFiles/${systemToJetBrainsRid system}/${executable}" "$out/bin/${executable}"
              '') executables}
            ''
          else
            ''
              mkdir -p $out/{bin,lib/$pname}
              cp -a . $out/lib/$pname

              ${lib.getExe extract-dotnet-resources} "${iconHolder}" "*/ProductIcon"
              ${lib.getExe' icoutils "icotool"} -x */ProductIcon
              for f in ProductIcon_*.png; do
                res=$(basename "$f" | cut -d "_" -f3 | cut -d "x" -f1-2)
                install -vD "$f" "$out/share/icons/hicolor/$res/apps/$pname.png"
              done
            ''
        )
        + ''
          runHook postInstall
        '';

      dontWrapGApps = true;

      fixupPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
        runHook preFixup

        wrapDotnetProgram() {
            makeWrapper "$1" "$2" \
                --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath avaloniaDependencies}" \
                --set DOTNET_ROOT "${dotnet-runtime}" \
                --prefix PATH : "${dotnet-runtime}/bin" \
                "''${gappsWrapperArgs[@]}" \
                "''${makeWrapperArgs[@]}"
        }

        ${lib.concatMapStringsSep "\n" (executable: ''
          wrapDotnetProgram "$out/lib/$pname/${systemToJetBrainsRid system}/${executable}" "$out/bin/${executable}"
        '') executables}

        runHook postFixup
      '';

      desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
        (makeDesktopItem {
          name = finalAttrs.pname;
          exec = finalAttrs.meta.mainProgram;
          inherit desktopName;
          categories = [ "Development" ];
          icon = finalAttrs.pname;
          startupWMClass = "JetBrains ${desktopName}";
        })
      ];

      meta = {
        license = lib.licenses.unfree;
        mainProgram = builtins.head executables;
        sourceProvenance = with lib.sourceTypes; [
          binaryNativeCode
          binaryBytecode
        ];
        platforms = builtins.attrNames sources;
      } // meta;

      passthru.updateScript = writeShellScript "update-jetbrains.${finalAttrs.pname}" ''
        set -eu -o pipefail
        PATH="$PATH:${
          lib.makeBinPath [
            curl
            jq
            common-updater-scripts
          ]
        }"

        latest_release=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=${code}&latest=true&type=release' | jq -r '.${code}[0]')
        version=$(jq -r '.version' <<< "$latest_release")

        function update_system() {
          local system="$1"
          local jetbrains_platform="$2"

          local download=$(jq -r ".downloads[\"$jetbrains_platform\"]" <<< "$latest_release")
          local download_url=$(jq -r '.link' <<< "$download")
          local download_sha256=$(curl -s "$(jq -r ".checksumLink" <<< "$download")" | cut -d ' ' -f1)

          update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" "$download_sha256" "$download_url" \
            --system="$system" --ignore-same-version
        }

        ${lib.concatMapStringsSep "\n" (
          system:
          "update_system ${
            lib.escapeShellArgs [
              system
              (systemToJetBrainsPlatform system)
            ]
          }"
        ) finalAttrs.meta.platforms}
      '';
    });

  callPackage = newScope { inherit mkJetBrainsAvaloniaProduct; };
in
{
  dotmemory = callPackage ./dotmemory.nix { };
  dottrace = callPackage ./dottrace.nix { };
}
