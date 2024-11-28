{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nixosTests,
  opentelemetry-collector-builder,
  pkgs,
  go,
  git,
  cacert,
  stdenv,
}:
let
  # This is the tool OTEL uses to build their distributions.
  builder = "${opentelemetry-collector-builder}/bin/ocb";

  # Keep the version in sync with the builder.
  rev = opentelemetry-collector-builder.src.rev;

  version = lib.removePrefix "cmd/builder/v" rev;

  # This is a weird meta-repo where all the open-telemetry collectors are.
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-releases";
    rev = "v${version}";
    hash = "sha256-wHi3/rby/AA37x3BCbTXlLgRaN4DpATLSXpQb31Jr/o=";
  };

  # Then from this src, we use the tool to generate some go code, including
  # the go.mod and go.sum files.
  #
  # The output depends on which release.
  mkDistributionSource =
    {
      name,
      hash,
    }:
    stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [
        cacert
        git
        go
      ];

      inherit src;

      outputHash = hash;
      outputHashMode = "recursive";
      outputHashAlgo = if hash == "" then "sha256" else null;

      patchPhase = ''
        patchShebangs .
      '';

      configurePhase = ''
        export HOME=$NIX_BUILD_TOP/home
        export GIT_SSL_CAINFO=$NIX_SSL_CERT_FILE
      '';

      buildPhase = ''
        # Only generate the go code, skip compilation
        ./scripts/build.sh -d ${name} -b ${builder} -s true
      '';

      installPhase = ''
        mv ./distributions/${name}/_build $out

        # Make it reproducible
        rm $out/build.log
      '';
    };

  # Then, finally, we build the project as a normal go module package.
  mkDistribution =
    {
      name,
      sourceHash,
      vendorHash,
    }:
    let
      package = buildGoModule {
        pname = name;
        inherit version;

        src = mkDistributionSource {
          inherit name;
          hash = sourceHash;
        };

        inherit vendorHash;

        nativeBuildInputs = [ installShellFiles ];

        # upstream strongly recommends disabling CGO
        # additionally dependencies have had issues when GCO was enabled that weren't caught upstream
        # https://github.com/open-telemetry/opentelemetry-collector/blob/main/CONTRIBUTING.md#using-cgo
        CGO_ENABLED = 0;

        ldflags = [
          "-s"
          "-w"
        ];

        postInstall = ''
          # Fix binary name
          mv $out/bin/* $out/bin/$pname

          installShellCompletion --cmd ${name} \
            --bash <($out/bin/${name} completion bash) \
            --fish <($out/bin/${name} completion fish) \
            --zsh <($out/bin/${name} completion zsh)
        '';

        passthru.tests = {
          version = testers.testVersion {
            inherit package version;
            command = "${name} -v";
          };
        };

        meta = with lib; {
          homepage = "https://github.com/open-telemetry/opentelemetry-collector-releases";
          description = "OpenTelemetry Collector Official Releases";
          longDescription = ''
            The OpenTelemetry Collector offers a vendor-agnostic implementation on how
            to receive, process and export telemetry data. In addition, it removes the
            need to run, operate and maintain multiple agents/collectors in order to
            support open-source telemetry data formats (e.g. Jaeger, Prometheus, etc.)
            sending to multiple open-source or commercial back-ends.
          '';
          license = licenses.asl20;
          maintainers = with maintainers; [
            uri-canva
            jk
            zimbatm
          ];
          mainProgram = name;
        };
      };
    in
    package;
in
lib.recurseIntoAttrs {
  otelcol = mkDistribution {
    name = "otelcol";
    sourceHash = "sha256-EGO5ns2Xi0g8PvPGdzMVxMJcPXvxaZDDi4YaJnIUAFc=";
    vendorHash = "sha256-dCSOGT0n0I5Oxw30uNeg184Me7hwZUfDuvl1IOdVBeo=";
  };

  otelcol-contrib = mkDistribution {
    name = "otelcol-contrib";
    sourceHash = "sha256-1TIzfR9F6iwSwoDc08SdOWYH378Y3qjwOcQ4IDbHTWE=";
    vendorHash = "sha256-KObLO3bXqGL1WSTKbJjg+hYJ9sYU4rn9gC/o38U1XJI=";
  };

  otelcol-k8s = mkDistribution {
    name = "otelcol-k8s";
    sourceHash = "sha256-WffBw41dZ/e5/d22ny6611pFReUVeO5lmtqqfaSdGLs=";
    vendorHash = "sha256-3EVJxma9U7FTzt1jIxotavMespFpCpU/oAAKMC0ya2E=";
  };

  otelcol-otlp = mkDistribution {
    name = "otelcol-otlp";
    sourceHash = "sha256-YQ9dIY9MdX0WtuOnFCZapDDWSl02S/dlTNce6RV48MM=";
    vendorHash = "sha256-4wiIgYa9eHvGxDgLbqWPTus9zBznYJ4lpsIUvRjRYUQ=";
  };
}
