{ lib
, alsa-lib
, factorio-utils
, fetchurl
, libGL
, libICE
, libSM
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, libpulseaudio
, libxkbcommon
, makeDesktopItem
, makeWrapper
, releaseType
, stdenv
, wayland

, mods-dat ? null
, versionsJson ? ./versions.json
, username ? ""
, token ? "" # get/reset token at https://factorio.com/profile
, experimental ? false # true means to always use the latest branch
, ...
} @ args:

assert releaseType == "alpha"
  || releaseType == "headless"
  || releaseType == "demo";

let

  inherit (lib) importJSON;

  mods = args.mods or [ ];

  helpMsg = ''

    ===FETCH FAILED===
    Please ensure you have set the username and token with config.nix, or
    /etc/nix/nixpkgs-config.nix if on NixOS.

    Your token can be seen at https://factorio.com/profile (after logging in). It is
    not as sensitive as your password, but should still be safeguarded. There is a
    link on that page to revoke/invalidate the token, if you believe it has been
    leaked or wish to take precautions.

    Example:
    {
      packageOverrides = pkgs: {
        factorio = pkgs.factorio.override {
          username = "FactorioPlayer1654";
          token = "d5ad5a8971267c895c0da598688761";
        };
      };
    }

    Alternatively, instead of providing the username+token, you may manually
    download the release through https://factorio.com/download , then add it to
    the store using e.g.:

      releaseType=alpha
      version=0.17.74
      nix-prefetch-url file://\''$HOME/Downloads/factorio_\''${releaseType}_x64_\''${version}.tar.xz --name factorio_\''${releaseType}_x64-\''${version}.tar.xz

    Note the ultimate "_" is replaced with "-" in the --name arg!
  '';

  desktopItem = makeDesktopItem {
    name = "factorio";
    desktopName = "Factorio";
    comment = "A game in which you build and maintain factories.";
    exec = "factorio";
    icon = "factorio";
    categories = [ "Game" ];
  };

  branch = if experimental then "experimental" else "stable";

  # NB `experimental` directs us to take the latest build, regardless of its branch;
  # hence the (stable, experimental) pairs may sometimes refer to the same distributable.
  versions = importJSON versionsJson;
  binDists = makeBinDists versions;

  actual = binDists.${stdenv.hostPlatform.system}.${releaseType}.${branch} or (throw "Factorio ${releaseType}-${branch} binaries for ${stdenv.hostPlatform.system} are not available for download.");

  makeBinDists = versions:
    let
      f = path: name: value:
        if builtins.isAttrs value then
          if value ? "name" then
            makeBinDist value
          else
            builtins.mapAttrs (f (path ++ [ name ])) value
        else
          throw "expected attrset at ${toString path} - got ${toString value}";
    in
    builtins.mapAttrs (f [ ]) versions;
  makeBinDist = { name, version, tarDirectory, url, sha256, needsAuth }: {
    inherit version tarDirectory;
    src =
      if !needsAuth then
        fetchurl { inherit name url sha256; }
      else
        (lib.overrideDerivation
          (fetchurl {
            inherit name url sha256;
            curlOptsList = [
              "--get"
              "--data-urlencode"
              "username@username"
              "--data-urlencode"
              "token@token"
            ];
          })
          (_: {
            # This preHook hides the credentials from /proc
            preHook =
              if username != "" && token != "" then ''
                echo -n "${username}" >username
                echo -n "${token}"    >token
              '' else ''
                # Deliberately failing since username/token was not provided, so we can't fetch.
                # We can't use builtins.throw since we want the result to be used if the tar is in the store already.
                exit 1
              '';
            failureHook = ''
              cat <<EOF
              ${helpMsg}
              EOF
            '';
          }));
  };

  configBaseCfg = ''
    use-system-read-write-data-directories=false
    [path]
    read-data=$out/share/factorio/data/
    [other]
    check_updates=false
  '';

  updateConfigSh = ''
    #! $SHELL
    if [[ -e ~/.factorio/config.cfg ]]; then
      # Config file exists, but may have wrong path.
      # Try to edit it. I'm sure this is perfectly safe and will never go wrong.
      sed -i 's|^read-data=.*|read-data=$out/share/factorio/data/|' ~/.factorio/config.cfg
    else
      # Config file does not exist. Phew.
      install -D $out/share/factorio/config-base.cfg ~/.factorio/config.cfg
    fi
  '';

  modDir = factorio-utils.mkModDirDrv mods mods-dat;

  base = with actual; {
    pname = "factorio-${releaseType}";
    inherit version src;

    preferLocalBuild = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/{bin,share/factorio}
      cp -a data $out/share/factorio
      cp -a bin/${tarDirectory}/factorio $out/bin/factorio
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/bin/factorio
    '';

    passthru.updateScript =
      if (username != "" && token != "") then [
        ./update.py
        "--username=${username}"
        "--token=${token}"
      ] else null;

    meta = {
      description = "A game in which you build and maintain factories";
      longDescription = ''
        Factorio is a game in which you build and maintain factories.

        You will be mining resources, researching technologies, building
        infrastructure, automating production and fighting enemies. Use your
        imagination to design your factory, combine simple elements into
        ingenious structures, apply management skills to keep it working and
        finally protect it from the creatures who don't really like you.

        Factorio has been in development since spring of 2012, and reached
        version 1.0 in mid 2020.
      '';
      homepage = "https://www.factorio.com/";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [ Baughn elitak erictapen priegger lukegb ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "factorio";
    };
  };

  releases = rec {
    headless = base;
    demo = base // {

      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ libpulseaudio ];

      libPath = lib.makeLibraryPath [
        alsa-lib
        libGL
        libICE
        libSM
        libX11
        libXcursor
        libXext
        libXi
        libXinerama
        libXrandr
        libpulseaudio
        libxkbcommon
        wayland
      ];

      installPhase = base.installPhase + ''
        wrapProgram $out/bin/factorio                                \
          --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath \
          --run "$out/share/factorio/update-config.sh"               \
          --argv0 ""                                                 \
          --add-flags "-c \$HOME/.factorio/config.cfg"               \
          ${lib.optionalString (mods!=[]) "--add-flags --mod-directory=${modDir}"}

          # TODO Currently, every time a mod is changed/added/removed using the
          # modlist, a new derivation will take up the entire footprint of the
          # client. The only way to avoid this is to remove the mods arg from the
          # package function. The modsDir derivation will have to be built
          # separately and have the user specify it in the .factorio config or
          # right along side it using a symlink into the store I think i will
          # just remove mods for the client derivation entirely. this is much
          # cleaner and more useful for headless mode.

          # TODO: trying to toggle off a mod will result in read-only-fs-error.
          # not much we can do about that except warn the user somewhere. In
          # fact, no exit will be clean, since this error will happen on close
          # regardless. just prints an ugly stacktrace but seems to be otherwise
          # harmless, unless maybe the user forgets and tries to use the mod
          # manager.

        install -m0644 <(cat << EOF
        ${configBaseCfg}
        EOF
        ) $out/share/factorio/config-base.cfg

        install -m0755 <(cat << EOF
        ${updateConfigSh}
        EOF
        ) $out/share/factorio/update-config.sh

        mkdir -p $out/share/icons/hicolor/{64x64,128x128}/apps
        cp -a data/core/graphics/factorio-icon.png $out/share/icons/hicolor/64x64/apps/factorio.png
        cp -a data/core/graphics/factorio-icon@2x.png $out/share/icons/hicolor/128x128/apps/factorio.png
        ln -s ${desktopItem}/share/applications $out/share/
      '';
    };
    alpha = demo // {

      installPhase = demo.installPhase + ''
        cp -a doc-html $out/share/factorio
      '';
    };
  };

in
stdenv.mkDerivation (releases.${releaseType})
