{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  opentelemetry-collector-builder,
  go,
  git,
  cacert,
  curl,
  stdenv,
}:
let
  # This is the tool OTEL uses to build their distributions.
  builder = "${opentelemetry-collector-builder}/bin/ocb";

  # Keep the version in sync with the builder.
  version = "0.164.0";

  # This is a weird meta-repo where all the open-telemetry collectors are.
  releasesSrc = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-releases";
    rev = "v${version}";
    hash = "sha256-bkWU3J8P56Q9WHEVXOO24mpkVXIP6LrTtj/Isgi5g38=";
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
      # Inherit the version from the builder, so that updates there trigger
      # a rebuild here.
      inherit version;
      pname = "${name}-src";

      nativeBuildInputs = [
        cacert
        curl
        git
        go
      ];

      src = releasesSrc;

      outputHash = hash;
      outputHashMode = "recursive";
      outputHashAlgo = if hash == "" then "sha256" else null;
      # A fixed-output path must not reference the store; obi-src has scripts.
      dontPatchShebangs = true;

      patchPhase = ''
        patchShebangs .
      '';

      configurePhase = ''
        export HOME=$NIX_BUILD_TOP/home
        export GIT_SSL_CAINFO=$NIX_SSL_CERT_FILE
      '';

      buildPhase = ''
        # Fetches the OBI source that otelcol-contrib replaces into internal/obi-src;
        # a no-op for the other distributions.
        ./scripts/prepare-obi.sh ${name}

        # Only generate the go code, skip compilation
        ./scripts/build.sh -d ${name} -b ${builder} -s true
      '';

      installPhase = ''
        mv ./distributions/${name}/_build $out

        # go.mod replaces the OBI module with ../../../internal/obi-src, which is
        # outside $out. Keep a copy next to go.mod and point the replace at it.
        if [ -d internal/obi-src ]; then
          cp -r internal/obi-src $out/obi-src
          (cd $out && go mod edit -replace go.opentelemetry.io/obi=./obi-src)
        fi

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
      proxyVendor ? false,
    }:
    let
      package = buildGoModule {
        pname = name;
        inherit version;

        src = mkDistributionSource {
          inherit name;
          hash = sourceHash;
        };

        inherit proxyVendor vendorHash;

        # The collector is the root package; obi-src holds a replaced module.
        subPackages = [ "." ];

        nativeBuildInputs = [ installShellFiles ];

        # upstream strongly recommends disabling CGO
        # additionally dependencies have had issues when GCO was enabled that weren't caught upstream
        # https://github.com/open-telemetry/opentelemetry-collector/blob/main/CONTRIBUTING.md#using-cgo
        env.CGO_ENABLED = 0;

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

        passthru = {
          tests = {
            version = testers.testVersion {
              inherit package version;
              command = "${name} -v";
            };
          };
          # The updatescript for the builder updates the releases
          updateScript = null;
          inherit releasesSrc;
        };

        meta = {
          homepage = "https://github.com/open-telemetry/opentelemetry-collector-releases";
          description = "OpenTelemetry Collector Official Releases";
          longDescription = ''
            The OpenTelemetry Collector offers a vendor-agnostic implementation on how
            to receive, process and export telemetry data. In addition, it removes the
            need to run, operate and maintain multiple agents/collectors in order to
            support open-source telemetry data formats (e.g. Jaeger, Prometheus, etc.)
            sending to multiple open-source or commercial back-ends.
          '';
          license = lib.licenses.asl20;
          maintainers = with lib.maintainers; [
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
    sourceHash = "sha256-QL5omiqdiYi7BTim0T7cTWk1hGuvH+99QrSYKnhrMnM=";
    vendorHash = "sha256-q9bOIrX5jld79WrHCWcyHpwN4wukPest+tjpydkOr5E=";
  };

  otelcol-contrib = mkDistribution {
    name = "otelcol-contrib";
    sourceHash = "sha256-pN4pIx8oE7ZDLm/Zx9kWJv7Alcvj3fUTt4gaiw6B1To=";
    vendorHash = "sha256-sbVebT6TODLIEm/SiCIFgfjZNtFKqunPSH3ByPW9/zY=";
    proxyVendor = true; # hash mismatch between linux and darwin
  };

  otelcol-k8s = mkDistribution {
    name = "otelcol-k8s";
    sourceHash = "sha256-vvJLMSb8Jf+wMZ5hTRgSqxfapM2zs1UN68QNHnr5zaM=";
    vendorHash = "sha256-tBV8hRbBJVVfzH9kujr+xUV/bSdog9ix4+MOOYKEBvA=";
  };

  otelcol-otlp = mkDistribution {
    name = "otelcol-otlp";
    sourceHash = "sha256-pgJaFQ23G0WVm9KbZ6qC/2VBz699cy6TACIq7UYw3b4=";
    vendorHash = "sha256-jxCLq3aXxIcUJ8tywl7V1ocHeNyhLLTqfOGaz6JEfh8=";
  };
}
