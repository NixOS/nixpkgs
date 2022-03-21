{ stdenvNoCC
, lib
, fetchFromGitHub
, ffmpeg
, yt-dlp
, libsecret
, python3
, pkg-config
, nodejs
, electron
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, yarn2nix-moretea
, chromium
}:

stdenvNoCC.mkDerivation rec {
  pname = "Sharedown";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "kylon";
    repo = pname;
    rev = version;
    sha256 = "sha256-wQEP3fdp+Mhgoz873cgF65WouWtbEdCdXfLiVSmrjyA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Sharedown";
      exec = "Sharedown";
      icon = "Sharedown";
      comment = "An Application to save your Sharepoint videos for offline usage.";
      desktopName = "Sharedown";
      categories = [ "Network" "Archiving" ];
    })
  ];

  dontBuild = true;

  installPhase =
    let
      binPath = lib.makeBinPath ([
        ffmpeg
        yt-dlp
      ]);

      modules = yarn2nix-moretea.mkYarnModules {
        name = "${pname}-modules-${version}";
        inherit pname version;

        yarnFlags = yarn2nix-moretea.defaultYarnFlags ++ [
          "--production"
        ];

        pkgConfig = {
          keytar = {
            nativeBuildInputs = [
              python3
              pkg-config
            ];
            buildInputs = [
              libsecret
            ];
            postInstall = ''
              yarn --offline run build
              # Remove unnecessary store path references.
              rm build/config.gypi
            '';
          };
        };

        preBuild = ''
          # Set up headers for node-gyp, which is needed to build keytar.
          mkdir -p "$HOME/.cache/node-gyp/${nodejs.version}"

          # Set up version which node-gyp checks in <https://github.com/nodejs/node-gyp/blob/4937722cf597ccd1953628f3d5e2ab5204280051/lib/install.js#L87-L96> against the version in <https://github.com/nodejs/node-gyp/blob/4937722cf597ccd1953628f3d5e2ab5204280051/package.json#L15>.
          echo 9 > "$HOME/.cache/node-gyp/${nodejs.version}/installVersion"

          # Link node headers so that node-gyp does not try to download them.
          ln -sfv "${nodejs}/include" "$HOME/.cache/node-gyp/${nodejs.version}"
        '';

        packageJSON = "${src}/package.json";
        yarnLock = ./yarn.lock;
        yarnNix = ./yarndeps.nix;
      };
    in
    ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/share/Sharedown" "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"

      # Electron app
      cp -r *.js *.json sharedownlogo.png sharedown "${modules}/node_modules" "$out/share/Sharedown"

      # Desktop Launcher
      cp build/icon.png "$out/share/icons/hicolor/512x512/apps/Sharedown.png"

      # Install electron wrapper script
      makeWrapper "${electron}/bin/electron" "$out/bin/Sharedown" \
        --add-flags "$out/share/Sharedown" \
        --prefix PATH : "${binPath}" \
        --set PUPPETEER_EXECUTABLE_PATH "${chromium}/bin/chromium"

      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Application to save your Sharepoint videos for offline usage";
    homepage = "https://github.com/kylon/Sharedown";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jtojnar
    ];
    platforms = platforms.unix;
  };
}
