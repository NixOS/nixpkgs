{ stdenv, callPackage, fetchurl, makeWrapper
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi, mesa_noglu
, factorio-utils
, releaseType
, mods ? []
, username ? "" , password ? ""
}:

assert releaseType == "alpha" || releaseType == "headless";

with stdenv.lib;
let
  version = "0.13.20";
  isHeadless = releaseType == "headless";

  arch = if stdenv.system == "x86_64-linux" then {
    inUrl = "linux64";
    inTar = "x64";
  } else if stdenv.system == "i686-linux" then {
    inUrl = "linux32";
    inTar = "i386";
  } else abort "Unsupported platform";

  authenticatedFetch = callPackage ./fetch.nix { inherit username password; };

  fetch = rec {
    url = "https://www.factorio.com/get-download/${version}/${releaseType}/${arch.inUrl}";
    name = "factorio_${releaseType}_${arch.inTar}-${version}.tar.gz";
    x64 = {
      headless = fetchurl        { inherit name url; sha256 = "0nf1sxcgnbx52iwx7jgkjxass10lzz1iyskvgk0gq3ky9cg4ixfb"; };
      alpha = authenticatedFetch { inherit      url; sha256 = "0rgjdxdcqf9m3ghzr076q3xi1g01ix14jldjwn6jgnvggzqkph9l"; };
    };
    i386 = {
      headless = abort "Factorio 32-bit headless binaries are not available for download.";
      alpha = authenticatedFetch { inherit      url; sha256 = "0hda2z1q22xanl328kic5q09ck59mr3aa5cy4dbjv86s4dx9kxfq"; };
    };
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

  modDir = factorio-utils.mkModDirDrv mods;

  base = {
    name = "factorio-${releaseType}-${version}";

    src = fetch.${arch.inTar}.${releaseType};

    preferLocalBuild = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/{bin,share/factorio}
      cp -a data $out/share/factorio
      cp -a bin/${arch.inTar}/factorio $out/bin/factorio
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/bin/factorio
    '';

    meta = {
      description = "A game in which you build and maintain factories";
      longDescription = ''
        Factorio is a game in which you build and maintain factories.

        You will be mining resources, researching technologies, building
        infrastructure, automating production and fighting enemies. Use your
        imagination to design your factory, combine simple elements into
        ingenious structures, apply management skills to keep it working and
        finally protect it from the creatures who don't really like you.

        Factorio has been in development since spring of 2012 and it is
        currently in late alpha.
      '';
      homepage = https://www.factorio.com/;
      license = stdenv.lib.licenses.unfree;
      maintainers = with stdenv.lib.maintainers; [ Baughn elitak ];
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };
  headless = base;
  alpha = base // {

    buildInputs = [ makeWrapper ];

    libPath = stdenv.lib.makeLibraryPath [
      alsaLib
      libX11
      libXcursor
      libXinerama
      libXrandr
      libXi
      mesa_noglu
    ];

    installPhase = base.installPhase + ''
      wrapProgram $out/bin/factorio                                \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath \
        --run "$out/share/factorio/update-config.sh"               \
        --add-flags "-c \$HOME/.factorio/config.cfg ${optionalString (mods != []) "--mod-directory=${modDir}"}"

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

      cp -a doc-html $out/share/factorio
    '';
  };
in stdenv.mkDerivation (if isHeadless then headless else alpha)
