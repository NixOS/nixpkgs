{ stdenv, callPackage, fetchurl, makeWrapper
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi, mesa_noglu
, releaseType
, username ? "" , password ? ""
}:

assert releaseType == "alpha" || releaseType == "headless";

with stdenv.lib;
let
  version = "0.13.13";
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
      headless = fetchurl        { inherit name url; sha256 = "1ip0h2kh16s07nk6xqpm0i0yb0x32zn306414j15gqg3j0j0mzpn"; };
      alpha = authenticatedFetch { inherit      url; sha256 = "1hvj51cggp6cbxyndbl4z07kadzxxk3diiqkkv0jm9s0nrwvq9zr"; };
    };
    i386 = {
      headless = abort "Factorio 32-bit headless binaries are not available for download.";
      alpha = authenticatedFetch { inherit      url; sha256 = "14dwlakn7z8jziy0hgm3nskr7chp7753z1dakxlymz9h5653cx8b"; };
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
