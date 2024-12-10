{
  lib,
  stdenv,
  fetchurl,
  bison,
  buildPackages,
  pkgsBuildTarget,
}:

let
  mkJam =
    {
      pname,
      version,
      src,
      meta ? { },
    }:
    stdenv.mkDerivation {
      inherit pname version src;

      depsBuildBuild = [ buildPackages.stdenv.cc ];
      nativeBuildInputs = [ bison ];

      # Jam uses c89 conventions
      env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-std=c89";

      # Jambase expects ar to have flags.
      preConfigure = ''
        export AR="$AR rc"
      '';

      # When cross-compiling, we need to set the preprocessor macros
      # OSMAJOR/OSMINOR/OSPLAT to the values from the target platform, not the
      # host platform. This looks a little ridiculous because the vast majority of
      # build tools don't embed target-specific information into their binary, but
      # in this case we behave more like a compiler than a make(1)-alike.
      postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
        cat >>jam.h <<EOF
        #undef OSMAJOR
        #undef OSMINOR
        #undef OSPLAT
        $(
          ${pkgsBuildTarget.targetPackages.stdenv.cc}/bin/${pkgsBuildTarget.targetPackages.stdenv.cc.targetPrefix}cc -E -dM jam.h \
            | grep -E '^#define (OSMAJOR|OSMINOR|OSPLAT) '
        )
        EOF
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

      meta =
        with lib;
        {
          license = licenses.free;
          mainProgram = "jam";
          platforms = platforms.unix;
        }
        // meta;
    };
in
{
  jam =
    let
      pname = "jam";
      version = "2.6.1";

      base = mkJam {
        inherit pname version;

        src = fetchurl {
          url = "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/${pname}-${version}.tar";
          sha256 = "19xkvkpycxfsncxvin6yqrql3x3z9ypc1j8kzls5k659q4kv5rmc";
        };

        meta = with lib; {
          description = "Just Another Make";
          homepage = "https://www.perforce.com/resources/documentation/jam";
          maintainers = with maintainers; [
            impl
            orivej
          ];
        };
      };
    in
    base.overrideAttrs (oldAttrs: {
      makeFlags = (oldAttrs.makeFlags or [ ]) ++ [
        "CC=${buildPackages.stdenv.cc.targetPrefix}cc"
      ];
    });

  ftjam =
    let
      pname = "ftjam";
      version = "2.5.2";

      base = mkJam {
        inherit pname version;

        src = fetchurl {
          url = "https://downloads.sourceforge.net/project/freetype/${pname}/${version}/${pname}-${version}.tar.bz2";
          hash = "sha256-6JdzUAqSkS3pGOn+v/q+S2vOedaa8ZRDX04DK4ptZqM=";
        };

        meta = with lib; {
          description = "FreeType's enhanced, backwards-compatible Jam clone";
          homepage = "https://freetype.org/jam/";
          maintainers = with maintainers; [
            AndersonTorres
            impl
          ];
        };
      };
    in
    base.overrideAttrs (oldAttrs: {
      postPatch =
        (oldAttrs.postPatch or "")
        + ''
          substituteInPlace Jamfile --replace strip ${stdenv.cc.targetPrefix}strip
        '';

      # Doesn't understand how to cross compile once bootstrapped, so we'll just
      # use the Makefile for the bootstrapping portion.
      configurePlatforms = [
        "build"
        "target"
      ];
      configureFlags = (oldAttrs.configureFlags or [ ]) ++ [
        "CC=${buildPackages.stdenv.cc.targetPrefix}cc"
        "--host=${stdenv.buildPlatform.config}"
      ];
    });
}
