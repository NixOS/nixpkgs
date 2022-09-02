{ lib, stdenv, fetchurl, bison }:

let
  mkJam = { meta ? { }, ... } @ args: stdenv.mkDerivation (args // {
    nativeBuildInputs = [ bison ];

    # Jambase expects ar to have flags.
    preConfigure = ''
      export AR="$AR rc"
    '';

    installPhase = ''
      runHook preInstall

      ./jam0 -j$NIX_BUILD_CORES -sBINDIR=$out/bin install
      mkdir -p $out/doc/jam
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

    makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

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

    postPatch = ''
      substituteInPlace Jamfile --replace strip ${stdenv.cc.targetPrefix}strip
    '';

    src = fetchurl {
      url = "https://downloads.sourceforge.net/project/freetype/${pname}/${version}/${pname}-${version}.tar.bz2";
      hash = "sha256-6JdzUAqSkS3pGOn+v/q+S2vOedaa8ZRDX04DK4ptZqM=";
    };

    meta = with lib; {
      description = "FreeType's enhanced, backwards-compatible Jam clone";
      homepage = "https://freetype.org/jam/";
      maintainers = with maintainers; [ AndersonTorres impl ];
    };
  };
}
