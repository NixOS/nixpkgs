{ stdenv, callPackage, fetchurl, makeWrapper
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi, libGL
, factorio-utils
, releaseType
, mods ? []
, username ? "" , password ? ""
, experimental ? false
}:

assert releaseType == "alpha"
    || releaseType == "headless"
    || releaseType == "demo";

let

  # NB If you nix-prefetch-url any of these, be sure to add a --name arg,
  #    where the ultimate "_" (before the version) is changed to a "-".
  branch = if experimental then "experimental" else "stable";
  binDists = {
    x86_64-linux = let bdist = bdistForArch { inUrl = "linux64"; inTar = "x64"; }; in {
      alpha = {
        stable        = bdist { sha256 = "0gxa8wh0py4l1ym57sfq792kfh00khi0f9ykjlmjqqkdksyxgddf"; fetcher = authenticatedFetch; };
        experimental  = bdist { sha256 = "1iy3k9zrw3za9mabf89lfl8i20xfij66ih5vngz5xfyy99mwxiy6"; version = "0.16.35"; fetcher = authenticatedFetch; };
      };
      headless = {
        stable        = bdist { sha256 = "0n2j86af41dkbsyyy5lawjpdd7c0lvfdwxpwbj1m8v470i1g8zq4"; };
        experimental  = bdist { sha256 = "0x4miyva1lmiyv3lb4savdlycia1kzw6bri4qj9b2jmyw1dr8x8h"; version = "0.16.35"; };
      };
      demo = {
        stable        = bdist { sha256 = "1z04rdlcxnfwami0l5nm292w4ydfhr1s6rcl8hxrsa73d4xk5lch"; version = "0.16.36"; };
        experimental  = bdist { };
      };
    };
    i686-linux = let bdist = bdistForArch { inUrl = "linux32"; inTar = "i386"; }; in {
      alpha = {
        stable        = bdist { sha256 = "0nnfkxxqnywx1z05xnndgh71gp4izmwdk026nnjih74m2k5j086l"; version = "0.14.23"; nameMut = asGz; };
        experimental  = bdist { };
      };
      headless = {
        stable        = bdist { };
        experimental  = bdist { };
      };
      demo = {
        stable        = bdist { };
        experimental  = bdist { };
      };
    };
  };
  actual = binDists.${stdenv.system}.${releaseType}.${branch} or (throw "Factorio: unsupported platform");

  bdistForArch = arch: { sha256 ? null
                       , version ? "0.16.36"
                       , fetcher ? fetchurl
                       , nameMut ? x: x
                       }:
    if sha256 == null then
      throw "Factorio ${releaseType}-${arch.inTar} binaries are not (and were never?) available to download"
    else {
      inherit version arch;
      src = fetcher {
        inherit sha256;
        url = "https://www.factorio.com/get-download/${version}/${releaseType}/${arch.inUrl}";
        name = nameMut "factorio_${releaseType}_${arch.inTar}-${version}.tar.xz";
      };
    };
  authenticatedFetch = callPackage ./fetch.nix { inherit username password; };
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
