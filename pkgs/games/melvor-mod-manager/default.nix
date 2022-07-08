{ lib, mkYarnPackage, yarn2nix-moretea, fetchFromGitHub, electron, makeWrapper, makeDesktopItem, copyDesktopItems }:

mkYarnPackage rec {
  pname = "melvor-mod-manager";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "CherryMace";
    repo = pname;
    rev = "v${version}";
    sha256 = "TDOwo9wg3btVlVbwxbkvR+hIri3NKCD/fn9FcJuWo50=";
  };

  # Probably not the right fix
  ELECTRON_OVERRIDE_DIST_PATH = electron + "/bin/electron";

  packageJSON = ./package.json; #cheerio rc11+ broken
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  buildPhase = ''
    pushd deps/melvor-mod-manager
    yarn --offline electron:build --skipElectronBuild
    popd
  '';

  installPhase =
    let
      modules = yarn2nix-moretea.mkYarnModules {
        name = "${pname}-modules-${version}";
        inherit pname version packageJSON yarnLock yarnNix;

        # Using production module tree for the install saves significant space
        yarnFlags = yarn2nix-moretea.defaultYarnFlags ++ [
          "--production"
        ];
      };
    in
    ''
      runHook preInstall

      mkdir -p $out/share/melvor-mod-manager $out/share/icons/hicolor/512x512/apps
      cp -a deps/melvor-mod-manager/dist_electron/bundled/* $out/share/melvor-mod-manager
      rmdir $out/share/melvor-mod-manager/node_modules
      cp -a ${modules}/node_modules $out/share/melvor-mod-manager
      cp deps/melvor-mod-manager/build/m3-icon.png $out/share/icons/hicolor/512x512/apps/melvor-mod-manager.png
      makeWrapper ${electron}/bin/electron $out/bin/melvor-mod-manager \
        --add-flags "$out/share/melvor-mod-manager"

      runHook postInstall
    '';

  doDist = false;

  desktopItems = [
    (makeDesktopItem {
      name = "melvor-mod-manager";
      exec = "melvor-mod-manager";
      icon = "melvor-mod-manager";
      desktopName = "Melvor Mod Manager";
      #startupWMClass = "µPad";
      comment = meta.description;
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/CherryMace/melvor-mod-manager";
    description = "Injects extensions into the Steam version of Melvor Idle";
    maintainers = with maintainers; [ celestefox ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
