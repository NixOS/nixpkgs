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
, gnugrep
, nixosTests
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
        rev = "391a74625c1222dd180f069f1b61c3e069a3ba8c";
        hash = "sha256-fUY0dBj85k0QhnAoDzyBmmKmRh9oCYC6r6X4ukt7/L0=";
      in dedicatedServer: {
        version = "${unstableVersionMajor}-${builtins.substring 0 8 rev}";
        src = fetchArmagetron rev hash;
        extraBuildInputs = [ protobuf boost ]
          ++ lib.optionals (!dedicatedServer) [ glew ftgl freetype SDL2 SDL2_image SDL2_mixer ];
        extraNativeBuildInputs = [ bison ];
      };

    # https://gitlab.com/armagetronad/armagetronad/-/commits/hack-0.2.8-sty+ct+ap/?ref_type=heads
    "${latestVersionMajor}-sty+ct+ap" =
      let
        rev = "5a17cc9fb6e1e27a358711afbd745ae54d4a8c60";
        hash = "sha256-111C1j/hSaASGcvYy3//TyHs4Z+3fuiOvCmtcWLdFd4=";
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

      buildInputs = lib.singleton (libxml2.override { enableHttp = true; })
        ++ (resolvedParams.extraBuildInputs or []);

      nativeBuildInputs = [ autoconf automake gnum4 pkg-config which python3 ]
        ++ (resolvedParams.extraNativeBuildInputs or []);

      nativeInstallCheckInputs = [ gnugrep ]
        ++ lib.optional (!dedicatedServer) xvfb-run
        ++ (resolvedParams.extraNativeInstallCheckInputs or []);

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
        echo "Checking game info:" >&2
        version="$($run --version || true)"
        echo "  - Version: $version" >&2
        prefix="$($run --prefix || true)"
        echo "  - Prefix: $prefix" >&2
        rubber="$(($run --doc || true) | grep -m1 CYCLE_RUBBER)"
        echo "  - Docstring: $rubber" >&2

        if [[ "$version" != *"${resolvedParams.version}"* ]] || \
           [ "$prefix" != "$out" ] || \
           [[ ! "$rubber" =~ ^CYCLE_RUBBER[[:space:]]+Niceness[[:space:]]factor ]]; then
          echo "Something didn't match. :-(" >&2
          exit 1
        else
          echo "Everything is ok." >&2
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
            tests.armagetronad = nixosTests.armagetronad;
          };

      meta = with lib; {
        inherit mainProgram;
        homepage = "https://www.armagetronad.org";
        description = "Multiplayer networked arcade racing game in 3D similar to Tron";
        maintainers = with maintainers; [ numinit ];
        license = licenses.gpl2Plus;
        platforms = platforms.linux;
      };
    };
in
mkArmagetron srcs.${latestVersionMajor} dedicatedServer
