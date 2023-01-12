{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, git
, gzip
, nodejs-16_x
, yarn
}:

let
  version = "1.41.0";
  src = fetchFromGitHub {
    owner = "jaegertracing";
    repo = "jaeger";
    rev = "v${version}";
    sha256 = "aa0RdEMRuKrGkXlxkMpouB/c924xRc4m6XTqISX2vkQ=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nodejs = nodejs-16_x;
  yarn' = yarn.override { inherit nodejs; };

  buildJaeger = { name, description, linkUI ? false }:
    buildGoModule rec {
      pname = "jaeger-${name}";
      inherit version src;

      vendorHash = "sha256-4vja9pI+t8mIF3+f8u5m+gTgC48/HdhEB7sJMTCYz0A=";
      subPackages = [ "cmd/${name}" ];

      ldflags = [
        "-s"
        "-w"
        "-X github.com/jaegertracing/jaeger/pkg/version.latestVersion=v${version}"
      ];

      tags = lib.optional linkUI "ui";

      nativeBuildInputs = [ git ];

      preBuild = ''
        GIT_SHA=$(git rev-parse HEAD)
        DATE=$(TZ=UTC0 git show --quiet --date='format-local:%Y-%m-%dT%H:%M:%SZ' --format="%cd")
        ldflags+=" -X github.com/jaegertracing/jaeger/pkg/version.commitSHA=$GIT_SHA"
        ldflags+=" -X github.com/jaegertracing/jaeger/pkg/version.date=$DATE"
      '' + lib.optionalString linkUI ''
        cp --no-preserve=mode -r ${jaeger-ui}/* cmd/query/app/ui/actual/
        find cmd/query/app/ui/actual -type f | grep -v .gitignore | xargs gzip --no-name
      '';

      postInstall = ''
        mv $out/bin/${name} $out/bin/${pname}
      '';

      meta = with lib; {
        inherit description;
        homepage = "https://www.jaegertracing.io";
        license = licenses.asl20;
        maintainers = with maintainers; [ emilytrau ];
      };
    };

  yarnCache = stdenv.mkDerivation {
    pname = "jaeger-ui-yarn-cache";
    inherit version;

    src = "${src}/jaeger-ui";

    nativeBuildInputs = [ yarn' ];
    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn config set yarn-offline-mirror $out
      yarn install --frozen-lockfile --ignore-scripts --ignore-platform --ignore-engines
    '';

    installPhase = ''
      echo yarnCache
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-LfYTiVK0AYvp4RxBcL9+kmG52A6ZgAB9OU2d87VIW0Y=";
  };

  jaeger-ui = stdenv.mkDerivation {
    pname = "jaeger-ui";
    inherit version;

    src = "${src}/jaeger-ui";

    nativeBuildInputs = [
      git
      gzip
      nodejs
      yarn'
    ];

    configurePhase = ''
      export HOME=$(mktemp -d)

      # with the update of openssl3, some key ciphers are not supported anymore
      # this flag will allow those codecs again as a workaround
      # see https://medium.com/the-node-js-collection/node-js-17-is-here-8dba1e14e382#5f07
      # and https://github.com/vector-im/element-web/issues/21043
      export NODE_OPTIONS=--openssl-legacy-provider

      yarn --offline config set yarn-offline-mirror "${yarnCache}"
      yarn install --offline --ignore-scripts --ignore-platform --ignore-engines

      patchShebangs node_modules/ packages/ scripts/
    '';

    buildPhase = ''
      cd packages/plexus
      yarn --offline build
      yarn --offline link
      cd ../..

      cd packages/jaeger-ui
      yarn --offline link @jaegertracing/plexus
      yarn --offline build
    '';

    installPhase = ''
      cp -r build $out
    '';
  };
in
{
  jaeger-agent = buildJaeger {
    name = "agent";
    description = "Local daemon program which collects tracing data";
  };

  jaeger-all-in-one = buildJaeger {
    name = "all-in-one";
    description = "Jaeger all-in-one distribution with agent, collector and query in one process";
    linkUI = true;
  };

  jaeger-anonymizer = buildJaeger {
    name = "anonymizer";
    description = "Hashes fields of a trace for easy sharing";
  };

  jaeger-collector = buildJaeger {
    name = "collector";
    description = "Receives and processes traces from Jaeger agents and clients";
  };

  jaeger-es-index-cleaner = buildJaeger {
    name = "es-index-cleaner";
    description = "Purge old Jaeger indices from Elasticsearch";
  };

  jaeger-ingester = buildJaeger {
    name = "ingester";
    description = "Consumes spans from a particular Kafka topic and writes them to a configured storage";
  };

  jaeger-query = buildJaeger {
    name = "query";
    description = "Provides a Web UI and an API for accessing trace data";
    linkUI = true;
  };

  jaeger-remote-storage = buildJaeger {
    name = "remote-storage";
    description = "Allows sharing single-node storage implementations like memstore or Badger";
  };

  jaeger-tracegen = buildJaeger {
    name = "tracegen";
    description = "Generate a steady flow of simple traces useful for performance tuning";
  };
}
