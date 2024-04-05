{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, gitUpdater
, electron_26
, imagemagick
}:

let
  electron = electron_26;
in
buildNpmPackage rec {
  pname = "gfn-electron";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "hmlendea";
    repo = "gfn-electron";
    rev = "v${version}";
    hash = "sha256-iypcQ2Nx+xrB9w8fXJ8I7gduPZ+95sdxLFbDBs//4bY=";
  };

  npmDepsHash = "sha256-1k2pVVTlP9JpGv4U47aSGXldbCymOTTelUyMn+wXU9A=";
  makeCacheWritable = true;
  forceGitDeps = true;

  npmFlags = [ "--ignore-scripts" ];

  dontBuild = true;

  nativeBuildInputs = [ imagemagick ];

  buildInputs = [ electron ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gfn-electron
    cp -r . $out/share/gfn-electron

    mkdir $out/share/applications
    mv com.github.hmlendea.geforcenow-electron.desktop $out/share/applications/
    substituteInPlace \
        $out/share/applications/com.github.hmlendea.geforcenow-electron.desktop \
        --replace 'Exec=/opt/geforcenow-electron/geforcenow-electron' 'Exec=${pname}'

    # Generate and install icon files
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert icon.png -sample "$size"x"$size" \
        -background white -gravity south -extent "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/nvidia.png
    done

    makeWrapper '${electron}/bin/electron' "$out/bin/gfn-electron" \
      --inherit-argv0 \
      --add-flags "$out/share/gfn-electron" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --ozone-platform-hint=auto}}"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/hmlendea/gfn-electron";
    description = "Unofficial Linux Desktop client for Nvidia's GeForce NOW game streaming service";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dsuetin ];
    mainProgram = "gfn-electron";
  };
}
