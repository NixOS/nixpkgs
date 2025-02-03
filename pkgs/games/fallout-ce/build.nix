{ cmake
, fpattern
, lib
, SDL2
, stdenv
, writeShellScript

, extraBuildInputs ? [ ]
, extraMeta
, pname
, version
, src
}:

let
  launcher = writeShellScript "${pname}" ''
    set -eu
    assetDir="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}"
    [ -d "$assetDir" ] || mkdir -p "$assetDir"
    cd "$assetDir"

    notice=0 fault=0
    requiredFiles=(master.dat critter.dat)
    for f in "''${requiredFiles[@]}"; do
      if [ ! -f "$f" ]; then
        echo "Required file $f not found in $PWD, note the files are case-sensitive"
        notice=1 fault=1
      fi
    done

    if [ ! -d "data/sound/music" ]; then
      echo "data/sound/music directory not found in $PWD. This may prevent in-game music from functioning."
      notice=1
    fi

    if [ $notice -ne 0 ]; then
      echo "Please reference the installation instructions at https://github.com/alexbatalov/fallout2-ce"
    fi

    if [ $fault -ne 0 ]; then
      exit $fault;
    fi

    exec @out@/libexec/${pname} "$@"
  '';
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ] ++ extraBuildInputs;
  hardeningDisable = [ "format" ];
  cmakeBuildType = "RelWithDebInfo";

  postPatch = ''
    substituteInPlace third_party/fpattern/CMakeLists.txt \
      --replace "FetchContent_Populate" "#FetchContent_Populate" \
      --replace "{fpattern_SOURCE_DIR}" "${fpattern}/include" \
      --replace "$/nix/" "/nix/"
  '';

  installPhase = ''
    runHook preInstall

    install -D ${pname} $out/libexec/${pname}
    install -D ${launcher} $out/bin/${pname}
    substituteInPlace $out/bin/${pname} --subst-var out

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.sustainableUse;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux;
  } // extraMeta;
}
