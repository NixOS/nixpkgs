{ stdenv, callPackage, fetchurl, makeWrapper
# Begin libraries
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi, mesa_noglu
# Begin download parameters
, username ? ""
, password ? ""
, releaseType
}:

assert releaseType == "alpha" || releaseType == "headless";

with stdenv.lib;
let
  version = "0.12.28";
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
      alpha = authenticatedFetch { inherit      url; sha256 = "0vngfrjjib99k6czhg32rikfi36i3p3adx4mxc1z8bi5n70dbwqb"; };
    };
    i386 = {
      alpha = authenticatedFetch { inherit      url; sha256 = "10135rd9103x79i89p6fh5ssmw612012yyx3yyhb3nzl554zqzbm"; };
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

in

stdenv.mkDerivation rec {
  name = "factorio-${releaseType}-${version}";

  src = fetch.${arch.inTar}.${releaseType};

  libPath = stdenv.lib.makeLibraryPath (
    optionals (! isHeadless) [
      alsaLib
      libX11
      libXcursor
      libXinerama
      libXrandr
      libXi
      mesa_noglu
    ]
  );

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  # TODO detangle headless/normal mode wrapping, libs, etc.  test all urls 32/64/headless/gfx
  installPhase = ''
    mkdir -p $out/{bin,share/factorio}
    cp -a data $out/share/factorio
    cp -a bin/${arch.inTar}/factorio $out/bin/factorio
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/factorio

  '' + optionalString (! isHeadless) (''
    mv $out/bin/factorio $out/bin/factorio.${arch.inTar}
    makeWrapper $out/bin/factorio.${arch.inTar} $out/bin/factorio \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath \
      --run "$out/share/factorio/update-config.sh" \
      --add-flags "-c \$HOME/.factorio/config.cfg"
    # Fortunately, Factorio already supports system-wide installs.
    # Unfortunately it's a bit inconvenient to set the paths.
    install -m0644 <(cat << EOF
  '' + configBaseCfg + ''
    EOF
    ) $out/share/factorio/config-base.cfg

    install -m0755 <(cat << EOF
  '' + updateConfigSh + ''
    EOF
    ) $out/share/factorio/update-config.sh
    cp -a doc-html $out/share/factorio
  '');

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
    maintainers = with stdenv.maintainers; [ Baughn elitak ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
