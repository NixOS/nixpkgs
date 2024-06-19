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
, xvfb-run
, dedicatedServer ? false
}:

let
  latestVersionMajor = "0.2.9";
  unstableVersionMajor = "0.4";

  srcs =
  let
    fetchArmagetron = rev: hash:
      fetchFromGitLab {
        owner = "armagetronad";
        repo = "armagetronad";
        inherit rev hash;
      };
  in
  {
    # https://gitlab.com/armagetronad/armagetronad/-/tags
    ${latestVersionMajor} =
      let
        version = "${latestVersionMajor}.2.3";
        rev = "v${version}";
        hash = "sha256-lfYJ3luGK9hB0aiiBiJIqq5ddANqGaVtKXckbo4fl2g=";
      in dedicatedServer: {
        inherit version;
        src = fetchArmagetron rev hash;
        extraBuildInputs = lib.optionals (!dedicatedServer) [ libpng SDL SDL_image SDL_mixer ];
      };

    # https://gitlab.com/armagetronad/armagetronad/-/commits/trunk/?ref_type=heads
    ${unstableVersionMajor} =
      let
        rev = "e7f41fd26363e7c6a72f0c673470ed06ab54ae08";
        hash = "sha256-Uxxk6L7WPxKYQ4CNxWwEtvbZjK8BqYNTuwwdleZ44Ro=";
      in dedicatedServer: {
        version = "${unstableVersionMajor}-${builtins.substring 0 8 rev}";
        src = fetchArmagetron rev hash;
        extraBuildInputs = [ protobuf boost ]
          ++ lib.optionals (!dedicatedServer) [ glew ftgl freetype SDL2 SDL2_image SDL2_mixer ];
        extraNativeBuildInputs = [ bison ];
        extraNativeInstallCheckInputs = lib.optionals (!dedicatedServer) [ xvfb-run ];
      };

    # https://gitlab.com/armagetronad/armagetronad/-/commits/hack-0.2.8-sty+ct+ap/?ref_type=heads
    "${latestVersionMajor}-sty+ct+ap" =
      let
        rev = "a5bffe9dda2b43d330433f76f14eb374701f326a";
        hash = "sha256-cNABxfg3MSmbxU/R78QyPOMwXGqJEamaFOPNw5yhDGE=";
      in dedicatedServer: {
        version = "${latestVersionMajor}-sty+ct+ap-${builtins.substring 0 8 rev}";
        src = fetchArmagetron rev hash;
        extraBuildInputs = lib.optionals (!dedicatedServer) [ libpng SDL SDL_image SDL_mixer ];
      };
  };

  # Creates an Armagetron build. Takes a function returning build inputs for a particular value of dedicatedServer.
  mkArmagetron = fn: dedicatedServer:
  let
    # Compute the build params.
    resolvedParams = fn dedicatedServer;

    # Figure out the binary name depending on whether this is a dedicated server.
    mainProgram = if dedicatedServer then "armagetronad-dedicated" else "armagetronad";

    # Split the version into the major and minor parts
    versionParts = lib.splitString "-" resolvedParams.version;
    splitVersion = lib.splitVersion (builtins.elemAt versionParts 0);
    majorVersion = builtins.concatStringsSep "." (lib.lists.take 2 splitVersion);

    minorVersionPart = parts: sep: expectedSize:
      if builtins.length parts > expectedSize then
        sep + (builtins.concatStringsSep sep (lib.lists.drop expectedSize parts))
      else
        "";

    minorVersion = (minorVersionPart splitVersion "." 2) + (minorVersionPart versionParts "-" 1) + "-nixpkgs";
  in
    stdenv.mkDerivation {
      pname = mainProgram;
      inherit (resolvedParams) version src;

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

      buildInputs = [ libxml2 ]
        ++ (resolvedParams.extraBuildInputs or []);

      nativeBuildInputs = [ autoconf automake gnum4 pkg-config which python3 ]
        ++ (resolvedParams.extraNativeBuildInputs or []);

      nativeInstallCheckInputs = resolvedParams.extraNativeInstallCheckInputs or [];

      postInstall = lib.optionalString (!dedicatedServer) ''
        mkdir -p $out/share/{applications,icons/hicolor}
        ln -s $out/share/games/armagetronad/desktop/armagetronad*.desktop $out/share/applications/
        ln -s $out/share/games/armagetronad/desktop/icons $out/share/icons/hicolor
      '';

      doInstallCheck = true;

      installCheckPhase = ''
        export XDG_RUNTIME_DIR=/tmp
        bin="$out/bin/${mainProgram}"
        if command -v xvfb-run &>/dev/null; then
          run="xvfb-run $bin"
        else
          run="$bin"
        fi
        version="$($run --version || true)"
        prefix="$($run --prefix || true)"
        rubber="$($run --doc | grep -m1 CYCLE_RUBBER)"

        echo "Version: $version" >&2
        echo "Prefix: $prefix" >&2
        echo "Docstring: $rubber" >&2

        if [[ "$version" != *"${resolvedParams.version}"* ]] || \
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
        else if (resolvedParams.version != (srcs.${latestVersionMajor} dedicatedServer).version) then {
          # Allow a "dedicated" passthru for versions other than the default.
          dedicated = mkArmagetron fn true;
        }
        else
          (
            lib.mapAttrs (name: value: mkArmagetron value dedicatedServer)
            (lib.filterAttrs (name: value: (value dedicatedServer).version != (srcs.${latestVersionMajor} dedicatedServer).version) srcs)
          ) //
          {
            # Allow both a "dedicated" passthru and a passthru for all the options other than the latest version, which this is.
            dedicated = mkArmagetron fn true;
          };

      meta = with lib; {
        inherit mainProgram;
        homepage = "https://www.armagetronad.org";
        description = "A multiplayer networked arcade racing game in 3D similar to Tron";
        maintainers = with maintainers; [ numinit ];
        license = licenses.gpl2Plus;
        platforms = platforms.linux;
      };
    };
in
mkArmagetron srcs.${latestVersionMajor} dedicatedServer
