{ stdenv, fetchurl, pkgconfig, unzip, zlib, libpng, bzip2, SDL, SDL_mixer
, buildEnv, config
}:

let
  # Choose your "paksets" of objects, images, text, music, etc.
  paksets = config.simutrans.paksets or "pak64 pak128";

  result = with stdenv.lib; withPaks (
    if paksets == "*" then attrValues pakSpec # taking all
      else map (name: pakSpec.${name}) (splitString " " paksets)
  );

  ver1 = "120";
  ver2 = "0";
  ver3 = "1";
  version =   "${ver1}.${ver2}.${ver3}";
  ver_dash =  "${ver1}-${ver2}-${ver3}";
  ver2_dash = "${ver1}-${ver2}";

  binary_src = fetchurl {
    url = "mirror://sourceforge/simutrans/simutrans/${ver_dash}/simutrans-src-${ver_dash}.zip";
    sha256 = "10rn259nxq2hhfpar8zwgxi1p4djvyygcm2f6qhih7l9clvnw2h1";
  };


  # As of 2015/03, many packsets still didn't have a release for version 120.
  pakSpec = stdenv.lib.mapAttrs
    (pakName: attrs: mkPak (attrs // {inherit pakName;}))
  {
    pak64 = {
      srcPath = "${ver2_dash}/simupak64-${ver_dash}";
      sha256 = "0y5v1ncpjyhjkkznqmk13kg5d0slhjbbvg1y8q5jxhmhlkghk9q2";
    };
    "pak64.japan" = {
      srcPath = "${ver2_dash}/simupak64.japan-${ver_dash}";
      sha256 = "14swy3h4ij74bgaw7scyvmivfb5fmp21nixmhlpk3mav3wr3167i";
    };

    pak128 = {
      srcPath = "pak128%20for%20ST%20120%20%282.5.2%2B%20nightly%20r1560%2C%20bugfixes%29/pak128-r1560--ST120";
      sha256 = "1wd51brc4aglqi3w7s8fxgxrw0k7f653w4wbnmk83k07fwfdyf24";
    };
    "pak128.britain" = {
      srcPath = "pak128.Britain%20for%20${ver2_dash}/pak128.Britain.1.16-${ver2_dash}";
      sha256 = "1rww9rnpk22l2z3s1d7y2gmd6iwhv72s7pff8krnh7z0q386waak";
    };
    "pak128.cs" = { # note: it needs pak128 to work
      url = "mirror://sourceforge/simutrans/Pak128.CS/pak128.cz_v.0.2.1.zip";
      sha256 = "008d8x1s0vxsq78rkczlnf57pv1n5hi1v5nbd1l5w3yls7lk11sc";
    };
    "pak128.german" = {
      url = "mirror://sourceforge/simutrans/PAK128.german/"
        + "PAK128.german_0.7_${ver1}.x/PAK128.german_0.7.0.1_${ver1}.x.zip";
      sha256 = "1575akms18raxaijy2kfyqm07wdx6y5q85n7wgvq2fqydrnx33w8";
    };

    /* This release contains accented filenames that prevent unzipping.
    "pak192.comic" = {
      srcPath = "pak192comic%20for%20${ver2_dash}/pak192comic-0.4-${ver2_dash}up";
      sha256 = throw "";
    };
    */
  };


  mkPak = {
    sha256, pakName, srcPath ? null
    , url ? "mirror://sourceforge/simutrans/${pakName}/${srcPath}.zip"
  }:
    stdenv.mkDerivation {
      name = "simutrans-${pakName}";
      unpackPhase = "true";
      installPhase = let src = fetchurl { inherit url sha256; };
      in ''
        mkdir -p "$out/share/simutrans/${pakName}"
        cd "$out/share/simutrans/${pakName}"
        "${unzip}/bin/unzip" "${src}"
        chmod -R +w . # some zipfiles need that

        set +o pipefail # no idea why it's needed
        toStrip=`find . -iname '*.pak' | head -n 1 | sed 's|\./\(.*\)/[^/]*$|\1|'`
        echo "Detected path '$toStrip' to strip"
        mv ./"$toStrip"/* .
        rmdir -p "$toStrip"
      '';
    };

  /* The binaries need all data in one directory; the default is directory
      of the executable, and another option is the current directory :-/ */
  withPaks = paks: buildEnv {
    inherit (binaries) name;
    paths = [binaries] ++ paks;
    postBuild = ''
      rm "$out/bin" && mkdir "$out/bin"
      cat > "$out/bin/simutrans" <<EOF
      #!${stdenv.shell}
      cd "$out"/share/simutrans
      exec "${binaries}/bin/simutrans" -use_workdir "\''${extraFlagsArray[@]}" "\$@"
      EOF
      chmod +x "$out/bin/simutrans"
    '';

    passthru.meta = binaries.meta // { hydraPlatforms = []; };
    passthru.binaries = binaries;
  };

  binaries = stdenv.mkDerivation rec {
    name = "simutrans-${version}";

    src = binary_src;

    sourceRoot = ".";

    buildInputs = [ pkgconfig zlib libpng bzip2 SDL SDL_mixer unzip ];

    configurePhase = let
      # Configuration as per the readme.txt and config.template
      platform =
        if stdenv.isLinux then "linux" else
        if stdenv.isDarwin then "mac" else throw "add your platform";
      config = ''
        BACKEND = mixer_sdl
        COLOUR_DEPTH = 16
        OSTYPE = ${platform}
        VERBOSE = 1
      '';
      #TODO: MULTI_THREAD = 1 is "highly recommended",
      # but it's roughly doubling CPU usage for me
    in ''
      echo "${config}" > config.default

      # Use ~/.simutrans instead of ~/simutrans
      substituteInPlace simsys.cc --replace '%s/simutrans' '%s/.simutrans'

      # use -O2 optimization (defaults are -O or -O3)
      sed -i -e '/CFLAGS += -O/d' Makefile
      export CFLAGS+=-O2
    '';

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/share/
      mv simutrans $out/share/

      mkdir -p $out/bin/
      mv build/default/sim $out/bin/simutrans
    '';

    meta = with stdenv.lib; {
      description = "A simulation game in which the player strives to run a successful transport system";
      longDescription = ''
        Simutrans is a cross-platform simulation game in which the
        player strives to run a successful transport system by
        transporting goods, passengers, and mail between
        places. Simutrans is an open source remake of Transport Tycoon.
      '';

      homepage = http://www.simutrans.com/;
      license = with licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ kkallio vcunat ];
      platforms = with platforms; linux ++ darwin;
    };
  };

in result

