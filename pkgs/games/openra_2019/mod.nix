/*  The package defintion for an OpenRA out-of-tree mod.
    It shares code with `engine.nix` by what is defined in `common.nix`.
    To build an out-of-tree mod it needs the source code of the engine available,
    and they each need to be build with a specific version or fork of the engine,
    so the engine needs to be supplied as an argument as well.
    The engine is relatively small and quick to build, so this is not much of a problem.
    Building a mod will result in a wrapper script that starts the mod inside the specified engine.
*/
{ lib, stdenv
, packageAttrs
, patchEngine
, wrapLaunchGame
, mod
, engine
}:

let
  engineSourceName = engine.src.name or "engine";
  modSourceName = mod.src.name or "mod";

# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-ura
in stdenv.mkDerivation (lib.recursiveUpdate packageAttrs rec {
  name = "${pname}-${version}";
  pname = "openra_2019-${mod.name}";
  inherit (mod) version;

  srcs = [
    mod.src
    engine.src
  ];

  sourceRoot = ".";

  postUnpack = ''
    mv ${engineSourceName} ${modSourceName}
    cd ${modSourceName}
  '';

  postPatch = ''
    cat <<'EOF' > fetch-engine.sh
    #!/bin/sh
    exit 0
    EOF

    sed -i 's/^VERSION.*/VERSION = ${version}/g' Makefile

    dos2unix *.md

    ${patchEngine engineSourceName engine.version}
  '';

  configurePhase = ''
    runHook preConfigure

    make version VERSION=${lib.escapeShellArg version}
    make -C ${engineSourceName} version VERSION=${lib.escapeShellArg engine.version}

    runHook postConfigure
  '';

  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    make -C ${engineSourceName} install-engine install-common-mod-files DATA_INSTALL_DIR=$out/lib/${pname}

    cp -r ${engineSourceName}/mods/{${lib.concatStringsSep "," ([ "common" "modcontent" ] ++ engine.mods)}} mods/* \
      $out/lib/${pname}/mods/

    substitute ${./mod-launch-game.sh} $out/lib/openra_2019-${mod.name}/launch-game.sh \
      --subst-var out \
      --subst-var-by name ${lib.escapeShellArg mod.name} \
      --subst-var-by title ${lib.escapeShellArg mod.title} \
      --subst-var-by assetsError ${lib.escapeShellArg mod.assetsError}
    chmod +x $out/lib/openra_2019-${mod.name}/launch-game.sh

    ${wrapLaunchGame "_2019-${mod.name}" "openra-${mod.name}"}

    substitute ${./openra-mod.desktop} $(mkdirp $out/share/applications)/${pname}.desktop \
      --subst-var-by name ${lib.escapeShellArg mod.name} \
      --subst-var-by title ${lib.escapeShellArg mod.title} \
      --subst-var-by description ${lib.escapeShellArg mod.description}

    cp README.md $(mkdirp $out/share/doc/packages/${pname})/README.md

    [[ -e mods/${mod.name}/icon.png ]] && mod_icon=mods/${mod.name}/icon.png || {
      [[ -e mods/${mod.name}/logo.png ]] && mod_icon=mods/${mod.name}/logo.png || mod_icon=packaging/linux/mod_256x256.png
    }
    cp "$mod_icon" $(mkdirp $out/share/pixmaps)/${pname}.png

    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png $(mkdirp $out/share/icons/hicolor/''${size}/apps)/${pname}.png
    done

    runHook postInstall
  '';

  meta = {
    inherit (mod) description homepage;
  };
})
