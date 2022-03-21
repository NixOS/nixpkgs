{ lib, stdenv, fetchurl, fetchFromGitHub, buildGoPackage, buildEnv

# The suffix for the Mattermost version.
, versionSuffix ? "nixpkgs"

# The constant build date.
, buildDate ? "1970-01-01"

# Set to true to set the build hash to the Nix store path.
, storePathAsBuildHash ? false }:

let
  version = "6.3.3";

  goPackagePath = "github.com/mattermost/mattermost-server";

  mattermost-server-build = buildGoPackage rec {
    pname = "mattermost-server";
    inherit version goPackagePath;

    src = fetchFromGitHub {
      owner = "mattermost";
      repo = "mattermost-server";
      rev = "v${version}";
      sha256 = "OSN8Bscgv7rPfKIfZ3ZnegdgsygFpSM7/vGWojj0P3k=";
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
      sha256 = "Og9DUGyE4cWYF7EQP/8szIrWM1Ldqnpqc+HW+L7XApo=";
    };

    installPhase = ''
      mkdir -p $out
      tar --strip 1 --directory $out -xf $src \
        mattermost/client \
        mattermost/i18n \
        mattermost/fonts \
        mattermost/templates \
        mattermost/config

      # For some reason a bunch of these files are +x...
      find $out -type f -exec chmod -x {} \;
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
