{ stdenv, callPackage, fetchurl, makeWrapper
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi, mesa_noglu
, releaseType
, username ? "" , password ? ""
}:

assert releaseType == "alpha" || releaseType == "headless";

with stdenv.lib;
let
  version = "0.12.33";
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
    name = "factorio_${releaseType}_${arch.inTar}-${version}.tar.gz"; # TODO take this from 302 redirection somehow? fetchurl doesn't help.
    x64 = {
      headless = fetchurl        { inherit name url; sha256 = "073bwkpw2bwhbr3m8k3imlns89x5035xl4b7yq1c6npm4m7qcdnp"; };
      alpha = authenticatedFetch { inherit      url; sha256 = "0dmq0kvzz885gcvj57h22icqhx0nvyfav4dvwsvpi15833208ca3"; };
    };
    i386 = {
      headless = abort "Factorio 32-bit headless binaries are not available for download.";
      alpha = authenticatedFetch { inherit      url; sha256 = "1yxv6kr89iavpfsg21fx3q12m97ls0m9h3x33m4xnqp8px55851v"; };
    };
  };

  configBaseCfg = ''
    use-system-read-write-data-directories=false
    [path]
    read-data=$out/share/factorio/data/
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

  base = {
    name = "factorio-${releaseType}-${version}";

    src = fetch.${arch.inTar}.${releaseType};

    dontBuild = true;

    # TODO detangle headless/normal mode wrapping, libs, etc.  test all urls 32/64/headless/gfx
    installPhase = ''
      mkdir -p $out/{bin,share/factorio}
      cp -a data $out/share/factorio
      cp -a bin/${arch.inTar}/factorio $out/bin/factorio
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/bin/factorio
    '';

    preferLocalBuild = true;

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
        --add-flags "-c \$HOME/.factorio/config.cfg"

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
