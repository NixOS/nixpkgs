{ lib, stdenv, fetchurl, fetchFromGitHub, buildGo117Package, buildEnv

# The suffix for the Mattermost version.
, versionSuffix ? "nixpkgs"

# The constant build date.
, buildDate ? "1970-01-01"

# Set to true to set the build hash to the Nix store path.
, storePathAsBuildHash ? false }:

let
  version = "6.2.1";

  goPackagePath = "github.com/mattermost/mattermost-server";

  mattermost-server-build = buildGo117Package rec {
    pname = "mattermost-server";
    inherit version goPackagePath;

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "WjBsbW7aEI+MX2I1LrEJh8JgNQ4Do7PpeshXgaQAk1s=";
    };

    ldflags = [
      "-s" "-w"
      "-X ${goPackagePath}/model.BuildNumber=${version}${lib.optionalString (versionSuffix != null) "-${versionSuffix}"}"
      "-X ${goPackagePath}/model.BuildDate=${buildDate}"
      "-X ${goPackagePath}/model.BuildEnterpriseReady=false"
    ];
  };

  mattermost-server = if storePathAsBuildHash then mattermost-server-build.overrideAttrs (orig: {
    buildPhase = ''
      origGo="$(type -p go)"

      # Override the Go binary to set the build hash in -ldflags to $out.
      # Technically this is more accurate than a Git hash!
      # nixpkgs does not appear to support environment variables in ldflags
      # for go packages, so we have to rewrite -ldflags before calling go.
      go() {
        local args=()
        local ldflags="-X ${goPackagePath}/model.BuildHash=$out"
        local found=0
        for arg in "$@"; do
          if [[ "$arg" == -ldflags=* ]] && [ $found -eq 0 ]; then
            arg="-ldflags=''${ldflags} ''${arg#-ldflags=}"
            found=1
          fi
          args+=("$arg")
        done
        "$origGo" "''${args[@]}"
      }

      ${orig.buildPhase}
    '';
  }) else mattermost-server-build;

  mattermost-webapp = stdenv.mkDerivation {
    pname = "mattermost-webapp";
    inherit version;

    src = fetchurl {
      url = "https://releases.mattermost.com/${version}/mattermost-${version}-linux-amd64.tar.gz";
      sha256 = "pV/MwMCK8vMzASXuM1+ePcarIgrcNAkFLEdmPya911E=";
    };

    installPhase = ''
      mkdir -p $out
      tar --strip 1 --directory $out -xf $src \
        mattermost/client \
        mattermost/i18n \
        mattermost/fonts \
        mattermost/templates \
        mattermost/config
    '';
  };

in
  buildEnv {
    name = "mattermost-${version}";
    paths = [ mattermost-server mattermost-webapp ];

    meta = with lib; {
      description = "Open-source, self-hosted Slack-alternative";
      homepage = "https://www.mattermost.org";
      license = with licenses; [ agpl3 asl20 ];
      maintainers = with maintainers; [ fpletz ryantm numinit ];
      platforms = platforms.unix;
    };
  }
