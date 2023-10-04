{ lib
, stdenv
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, buildGoModule
, darwin
, makeWrapper
, ffmpeg-full
, vips
}:

let
  pname = "stash";
  version = "0.22.1";

  # these hashes can be updated by update.sh
  gitHash = "113f0b7d";
  srcHash = "sha256-QtAZ9+ujqHm4lMGOf4tiBYio/LKAeBc6WPkfDH2mKOE=";
  yarnHash = "sha256-qP/9EK7rZQ7Wn0WQmrWcJhiD73S5I6TnSfYE0fJqFsI=";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = pname;
    rev = "v${version}";
    hash = srcHash;
  };
  uiSrc = "${src}/ui/v2.5";

  ui = mkYarnPackage {
    inherit version;
    pname = "${pname}-ui";

    src = uiSrc;
    packageJSON = "${uiSrc}/package.json";

    offlineCache = fetchYarnDeps {
      yarnLock = "${uiSrc}/yarn.lock";
      hash = yarnHash;
    };

    postPatch = ''
      substituteInPlace codegen.yml \
        --replace "../../graphql/" "${src}/graphql/"
    '';

    configurePhase = ''
      ln -s $node_modules node_modules
    '';

    buildPhase = ''
      export HOME=$(mktemp -d)
      export VITE_APP_DATE="1970-01-01 00:00:00"
      export VITE_APP_GITHASH=${gitHash}
      export VITE_APP_STASH_VERSION=v${version}
      export VITE_APP_NOLEGACY=true

      yarn --offline run gqlgen
      yarn --offline build
    '';

    installPhase = "mv build $out";

    distPhase = "true";
  };
in
buildGoModule rec {
  inherit pname version src;

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/stashapp/stash/internal/build.buildstamp=1970-01-01 00:00:00'"
    "-X 'github.com/stashapp/stash/internal/build.githash=${gitHash}'"
    "-X 'github.com/stashapp/stash/internal/build.version=v${version}'"
    "-X 'github.com/stashapp/stash/internal/build.officialBuild=true'"
  ];
  tags = [ "sqlite_stat4" ];

  subPackages = [ "cmd/stash" ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Cocoa WebKit ]);

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    cp -R ${ui} ui/v2.5/build

    # `go mod tidy` requires internet access and does nothing
    echo "skip_mod_tidy: true" >> gqlgen.yml

    # unset `GOFLAGS` because `gqlgen` does not work with `-trimpath`
    GOFLAGS="" go generate ./cmd/stash
  '';

  postFixup = ''
    wrapProgram $out/bin/stash --prefix PATH : "${lib.makeBinPath [ ffmpeg-full vips ]}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An organizer for your porn, written in Go.";
    homepage = "https://stashapp.cc/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ halfdrie ];
    platforms = lib.platforms.all;
  };
}
