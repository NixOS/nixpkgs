{ lib
, stdenv
, fetchzip
, requireFile
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, xdelta

, openssl_1_0_2
, openalSoft
, libXxf86vm
, libglvnd
, libXrandr
, libGLU
, curl
, jstest-gtk

, hqMusic ? true
, modifiersIni ? null

, patchPath ? null # Must point to the data folder
, pname ? "am2r"
, desktopName ? "AM2R"
, version ? "1.5.5"
, meta ? with lib; {
    description = "Another Metroid 2 Remake (Community Edition)";
    longDescription = "Another Metroid 2 Remake is an unofficial fan remake of Metroid II: Return of Samus, with community patches";
    homepage = "https://github.com/AM2R-Community-Developers/AM2RLauncher";
    changelog = "https://am2r-community-developers.github.io/DistributionCenter/changelog.html";
    # Incredibly unsure if it's the license I should use
    license = licenses.gpl3; # https://github.com/AM2R-Community-Developers/AM2R-Autopatcher-Linux/blob/master/LICENSE
    maintainers = [ maintainers.martfont ];
    platforms = platforms.linux;
    hydraPlatforms = [];
    broken = true; # The executable segfaults
  }
}:

stdenv.mkDerivation rec {
  inherit pname version meta;
  # Maybe this should make the derivation unfree...
  src = requireFile rec {
    name = "AM2R_11";
    hashMode = "recursive";
    sha256 = "0hbh9cqals6f97vxkv2fmqv1irysld2ipg4v1yal0fk9jv47qyx1";
    message = ''
      Due to Nintendo's DMCA takedown, we cannot download the original AM2R 1.1 zip automatically.
      Please retrieve the original file yourself, extract the contents to a folder named ${name},
      and add it to the Nix store using
        nix-store --add-fixed --recursive sha256 ${name}
    '';
  };
  communityPatch = fetchzip {
    url = "https://github.com/AM2R-Community-Developers/AM2R-Autopatcher-Linux/releases/download/Patchdata-v25/PatchData-V25.zip";
    sha256 = "sha256-7ReVBKDruJ0mPkciOAaMJPG/H7ky1Xdd6g7O3bUFaY0=";
  } + "/data";

  # https://github.com/AM2R-Community-Developers/AM2R-Autopatcher-Linux/blob/master/README.md#arch-including-manjaro-endeavouros-rebornos-etc-1
  buildInputs = [
    openssl_1_0_2
    openalSoft
    libXxf86vm
    libglvnd
    libXrandr
    libGLU
    curl
    jstest-gtk
  ];
  nativeBuildInputs = [
    autoPatchelfHook
    xdelta
    copyDesktopItems
  ];
  # For some reason it doesn't appear in the application list.
  desktopItems = lib.singleton (makeDesktopItem {
    inherit desktopName;
    name = pname;
    exec = pname;
    icon = "icon";
    type = "Application";
    categories = [ "Game" ];
    comment = meta.description;
  });

  patch = if patchPath != null then patchPath else communityPatch;

  # https://github.com/AM2R-Community-Developers/AM2RLauncher/blob/main/AM2RLauncher/AM2RLauncherCore/Profile.cs#L323
  buildPhase = ''
    mkdir -p $out/bin
    xdelta3 -d -s $src/data.win $patch/game.xdelta $out/bin/game.unx
    xdelta3 -d -s $src/AM2R.exe $patch/AM2R.xdelta $out/bin/${pname}
  '';
  installPhase = ''
    runHook preInstall

    cp -r $src $out/bin/assets/
    chmod a+w -R $out/bin/assets
    cp -r $patch/files_to_copy/. $out/bin/assets/

    mkdir -p $out/share/icons/hicolor/72x72/apps
    mv $out/bin/assets/icon.png $out/share/icons/hicolor/72x72/apps/

    rm $out/bin/assets/{D3DX9_43.dll,AM2R.exe,data.win}

    runHook postInstall
  ''
  # Extract high quality music from the community patch if it's not in the selected patch
  + lib.optionalString hqMusic (let hqMusicSource =
      if builtins.pathExists (patch + "/HDR_HQ_in-game_music") then patch else communityPatch;
    in ''
      cp -rf ${hqMusicSource}/HDR_HQ_in-game_music/. $out/bin/assets
    ''
    )
  + ''
    # Rename music to lowercase
    for file in $out/bin/assets/*.ogg; do
      mv -f $file $(echo $file | tr '[:upper:]' '[:lower:]') || true
    done
  '' + lib.optionalString (modifiersIni != null) ''
    cp -f $modifiersIni $out/bin/assets/modifiers.ini
  '';

  postFixup = ''
    chmod a+x $out/bin/${pname}
  '';
}
