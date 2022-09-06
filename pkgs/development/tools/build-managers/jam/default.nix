{ lib, stdenv, fetchurl, bison, buildPackages }:

let
  mkJam = { meta ? { }, ... } @ args: stdenv.mkDerivation (args // {
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ bison ];

    # Jambase expects ar to have flags.
    preConfigure = ''
      export AR="$AR rc"
    '';

    LOCATE_TARGET = "bin.unix";

    buildPhase = ''
      runHook preBuild
      make $makeFlags jam0
      ./jam0 -j$NIX_BUILD_CORES -sCC=${buildPackages.stdenv.cc.targetPrefix}cc jambase.c
      ./jam0 -j$NIX_BUILD_CORES
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/doc/jam
      cp bin.unix/jam $out/bin/jam
      cp *.html $out/doc/jam
      runHook postInstall
    '';

    enableParallelBuilding = true;

    meta = with lib; meta // {
      license = licenses.free;
      mainProgram = "jam";
      platforms = platforms.unix;
    };
  });
in
{
  jam = let
    pname = "jam";
    version = "2.6.1";
  in mkJam {
    inherit pname version;

    src = fetchurl {
      url = "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/${pname}-${version}.tar";
      sha256 = "19xkvkpycxfsncxvin6yqrql3x3z9ypc1j8kzls5k659q4kv5rmc";
    };

    meta = with lib; {
      description = "Just Another Make";
      homepage = "https://www.perforce.com/resources/documentation/jam";
      maintainers = with maintainers; [ impl orivej ];
    };
  };

  ftjam = let
    pname = "ftjam";
    version = "2.5.2";
  in mkJam {
    inherit pname version;

    src = fetchurl {
      url = "https://downloads.sourceforge.net/project/freetype/${pname}/${version}/${pname}-${version}.tar.bz2";
      hash = "sha256-6JdzUAqSkS3pGOn+v/q+S2vOedaa8ZRDX04DK4ptZqM=";
    };

    postPatch = ''
      substituteInPlace Jamfile --replace strip ${stdenv.cc.targetPrefix}strip
    '';

    # Doesn't understand how to cross compile once bootstrapped, so we'll just
    # use the Makefile for the bootstrapping portion.
    configurePlatforms = [ "build" "target" ];
    configureFlags = [
      "CC=${buildPackages.stdenv.cc.targetPrefix}cc"
      "--host=${stdenv.buildPlatform.config}"
    ];

    meta = with lib; {
      description = "FreeType's enhanced, backwards-compatible Jam clone";
      homepage = "https://freetype.org/jam/";
      maintainers = with maintainers; [ AndersonTorres impl ];
    };
  };
}
