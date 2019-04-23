{ stdenv, callPackage, fetchurl, makeWrapper
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi, libGL
, factorio-utils
, releaseType
, mods ? []
, username ? "", token ? "" # get/reset token at https://factorio.com/profile
, experimental ? false # true means to always use the latest branch
}:

assert releaseType == "alpha"
    || releaseType == "headless"
    || releaseType == "demo";

let

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
      version=0.16.51
      nix-prefetch-url file://$HOME/Downloads/factorio_\''${releaseType}_x64_\''${version}.tar.xz --name factorio_\''${releaseType}_x64-\''${version}.tar.xz

    Note the ultimate "_" is replaced with "-" in the --name arg!
  '';

  branch = if experimental then "experimental" else "stable";

  # NB `experimental` directs us to take the latest build, regardless of its branch;
  # hence the (stable, experimental) pairs may sometimes refer to the same distributable.
  binDists = {
    x86_64-linux = let bdist = bdistForArch { inUrl = "linux64"; inTar = "x64"; }; in {
      alpha = {
        stable        = bdist { sha256 = "0b4hbpdcrh5hgip9q5dkmw22p66lcdhnr0kmb0w5dw6yi7fnxxh0"; version = "0.16.51"; withAuth = true; };
        experimental  = bdist { sha256 = "0xgvvmyh49992y2r8yhafi80j3j4pcsp7pf0fg3rbc6zi1ariwsr"; version = "0.17.32"; withAuth = true; };
      };
      headless = {
        stable        = bdist { sha256 = "0zrnpg2js0ysvx9y50h3gajldk16mv02dvrwnkazh5kzr1d9zc3c"; version = "0.16.51"; };
        experimental  = bdist { sha256 = "1jfjbb0v7yiqpn7nxkr4fcd1rsz59s8k6qcl82d1j320l3y7nl9w"; version = "0.17.32"; };
      };
      demo = {
        stable        = bdist { sha256 = "0zf61z8937yd8pyrjrqdjgd0rjl7snwrm3xw86vv7s7p835san6a"; version = "0.16.51"; };
      };
    };
    i686-linux = let bdist = bdistForArch { inUrl = "linux32"; inTar = "i386"; }; in {
      alpha = {
        stable        = bdist { sha256 = "0nnfkxxqnywx1z05xnndgh71gp4izmwdk026nnjih74m2k5j086l"; version = "0.14.23"; withAuth = true; nameMut = asGz; };
      };
    };
  };

  actual = binDists.${stdenv.hostPlatform.system}.${releaseType}.${branch} or (throw "Factorio ${releaseType}-${branch} binaries for ${stdenv.hostPlatform.system} are not available for download.");

  bdistForArch = arch: { version
                       , sha256
                       , withAuth ? false
                       , nameMut ? x: x
                       }:
    let
      url = "https://factorio.com/get-download/${version}/${releaseType}/${arch.inUrl}";
      name = nameMut "factorio_${releaseType}_${arch.inTar}-${version}.tar.xz";
    in {
      inherit version arch;
      src =
        if withAuth then
          (stdenv.lib.overrideDerivation
            (fetchurl {
              inherit name url sha256;
              curlOpts = [
                "--get"
                "--data-urlencode" "username@username"
                "--data-urlencode" "token@token"
              ];
            })
            (_: { # This preHook hides the credentials from /proc
                  preHook = ''
                    echo -n "${username}" >username
                    echo -n "${token}"    >token
                  '';
                  failureHook = ''
                    cat <<EOF
                    ${helpMsg}
                    EOF
                  '';
            })
          )
        else
          fetchurl { inherit name url sha256; };
    };

  asGz = builtins.replaceStrings [".xz"] [".gz"];

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

  base = with actual; {
    name = "factorio-${releaseType}-${version}";

    inherit src;

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

  releases = rec {
    headless = base;
    demo = base // {

      buildInputs = [ makeWrapper ];

      libPath = stdenv.lib.makeLibraryPath [
        alsaLib
        libX11
        libXcursor
        libXinerama
        libXrandr
        libXi
        libGL
      ];

      installPhase = base.installPhase + ''
        wrapProgram $out/bin/factorio                                \
          --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath \
          --run "$out/share/factorio/update-config.sh"               \
          --argv0 ""                                                 \
          --add-flags "-c \$HOME/.factorio/config.cfg"               \
          ${if mods!=[] then "--add-flags --mod-directory=${modDir}" else ""}

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
      '';
    };
    alpha = demo // {

      installPhase = demo.installPhase + ''
        cp -a doc-html $out/share/factorio
      '';
    };
  };

in stdenv.mkDerivation (releases.${releaseType})
