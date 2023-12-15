{ lib
, stdenv
, fetchFromGitLab
, autoconf
, automake
, gnum4
, pkg-config
, bison
, python3
, which
, boost
, ftgl
, freetype
, glew
, SDL
, SDL_image
, SDL_mixer
, SDL2
, SDL2_image
, SDL2_mixer
, libpng
, libxml2
, protobuf
, dedicatedServer ? false
}:

let
  latestVersionMajor = "0.2.9";
  unstableVersionMajor = "0.4";

  latestCommonBuildInputs = [ SDL SDL_image SDL_mixer libpng ];

  unstableCommonBuildInputs = [ SDL2 SDL2_image SDL2_mixer glew ftgl freetype ];
  unstableCommonNativeBuildInputs = [ SDL ]; # for sdl-config

  srcs = {
    ${latestVersionMajor} = rec {
      version = "${latestVersionMajor}.1.1";
      src = fetchFromGitLab {
        owner = "armagetronad";
        repo = "armagetronad";
        rev = "v${version}";
        sha256 = "tvmKGqzH8IYTSeahc8XmN3RV+GdE5GsP8pAlwG8Ph3M=";
      };
      extraBuildInputs = latestCommonBuildInputs;
    };

    ${unstableVersionMajor} =
      let
        rev = "4bf6245a668ce181cd464b767ce436a6b7bf8506";
      in
      {
        version = "${unstableVersionMajor}-${builtins.substring 0 8 rev}";
        src = fetchFromGitLab {
          owner = "armagetronad";
          repo = "armagetronad";
          inherit rev;
          sha256 = "cpJmQHCS6asGasD7anEgNukG9hRXpsIJZrCr3Q7uU4I=";
        };
        extraBuildInputs = [ protobuf boost ] ++ unstableCommonBuildInputs;
        extraNativeBuildInputs = [ bison ] ++ unstableCommonNativeBuildInputs;
      };

    "${latestVersionMajor}-sty+ct+ap" =
      let
        rev = "fdfd5fb97083aed45467385b96d50d87669e4023";
      in
      {
        version = "${latestVersionMajor}-sty+ct+ap-${builtins.substring 0 8 rev}";
        src = fetchFromGitLab {
          owner = "armagetronad";
          repo = "armagetronad";
          inherit rev;
          sha256 = "UDbe7DiMLzNFAs4C6BbnmdEjqSltSbnk/uQfNOLGAfo=";
        };
        extraBuildInputs = latestCommonBuildInputs;
        extraNativeBuildInputs = [ python3 ];
      };
  };

  mkArmagetron = { version, src, dedicatedServer ? false, extraBuildInputs ? [ ], extraNativeBuildInputs ? [ ] }@params:
  let
    # Split the version into the major and minor parts
    versionParts = lib.splitString "-" version;
    splitVersion = lib.splitVersion (builtins.elemAt versionParts 0);
    majorVersion = builtins.concatStringsSep "." (lib.lists.take 2 splitVersion);

    minorVersionPart =  parts: sep: expectedSize:
      if builtins.length parts > expectedSize then
        sep + (builtins.concatStringsSep sep (lib.lists.drop expectedSize parts))
      else
        "";

    minorVersion = (minorVersionPart splitVersion "." 2) + (minorVersionPart versionParts "-" 1) + "-nixpkgs";
  in
    stdenv.mkDerivation rec {
      pname = if dedicatedServer then "armagetronad-dedicated" else "armagetronad";
      inherit version src;

      # Build works fine; install has a race.
      enableParallelBuilding = true;
      enableParallelInstalling = false;

      preConfigure = ''
        patchShebangs .

        # Create the version.
        echo "${majorVersion}" > major_version
        echo "${minorVersion}" > minor_version

        echo "Bootstrapping version: $(<major_version)$(<minor_version)" >&2
        ./bootstrap.sh
      '';

      configureFlags = [
        "--enable-automakedefaults"
        "--enable-authentication"
        "--disable-memmanager"
        "--disable-useradd"
        "--disable-initscripts"
        "--disable-etc"
        "--disable-uninstall"
        "--disable-sysinstall"
      ] ++ lib.optional dedicatedServer "--enable-dedicated"
        ++ lib.optional (!dedicatedServer) "--enable-music";

      buildInputs = [ libxml2 ] ++ extraBuildInputs;

      nativeBuildInputs = [ autoconf automake gnum4 pkg-config which python3 ]
        ++ extraNativeBuildInputs;

      doInstallCheck = true;

      installCheckPhase = ''
        export XDG_RUNTIME_DIR=/tmp
        bin="$out/bin/${pname}"
        version="$("$bin" --version || true)"
        prefix="$("$bin" --prefix || true)"
        rubber="$("$bin" --doc | grep -m1 CYCLE_RUBBER)"

        echo "Version: $version" >&2
        echo "Prefix: $prefix" >&2
        echo "Docstring: $rubber" >&2

        if [[ "$version" != *"${version}"* ]] || \
           [ "$prefix" != "$out" ] || \
           [[ ! "$rubber" =~ ^CYCLE_RUBBER[[:space:]]+Niceness[[:space:]]factor ]]; then
          exit 1
        fi
      '';

      passthru =
        if (dedicatedServer) then {
          # No passthru, end of the line.
          # https://www.youtube.com/watch?v=NOMa56y_Was
        }
        else if (version != srcs.${latestVersionMajor}.version) then {
          # Allow a "dedicated" passthru for versions other than the default.
          dedicated = mkArmagetron (params // {
            dedicatedServer = true;
          });
        }
        else (lib.mapAttrs (name: value: mkArmagetron value) (lib.filterAttrs (name: value: value.version != srcs.${latestVersionMajor}.version) srcs)) // {
          # Allow both a "dedicated" passthru and a passthru for all the options other than the latest version, which this is.
          dedicated = mkArmagetron (params // {
            dedicatedServer = true;
          });
        };

      meta = with lib; {
        homepage = "http://armagetronad.org";
        description = "A multiplayer networked arcade racing game in 3D similar to Tron";
        maintainers = with maintainers; [ numinit ];
        license = licenses.gpl2Plus;
        platforms = platforms.linux;
      };
    };
in
mkArmagetron (srcs.${latestVersionMajor} // { inherit dedicatedServer; })
