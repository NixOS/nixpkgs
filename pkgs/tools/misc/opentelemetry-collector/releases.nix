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
    hash = "sha256-w4J5Q7cztSQyjqHH5L0blDUiFO6+fK4/dLoQT+ftUSE=";
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

        passthru.tests = {
          version = testers.testVersion {
            inherit package version;
            command = "${name} -v";
          };
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
    sourceHash = "sha256-JY/jg5SeZ90lVLo+t6MuxZAMZ5IpNwEQEz9kC2uYc+8=";
    vendorHash = "sha256-tEA2wCtk2Pm7YJem5jOB/1Iz7K1jKKl/N9VKSumC+WA=";
  };

  otelcol-contrib = mkDistribution {
    name = "otelcol-contrib";
    sourceHash = "sha256-ANIyUa0bibTYRWC1RZbvYFitaEkmLOiubQxFfmzj4kQ=";
    vendorHash = "sha256-dPaDmhO4XASQ1y3NyetxnJuTr+pIDwF/rwrN5QkBBCA=";
    proxyVendor = true; # hash mismatch between linux and darwin
  };

  otelcol-k8s = mkDistribution {
    name = "otelcol-k8s";
    sourceHash = "sha256-cZ+ok52ceYkQE9bG+FFTFYONUQfsC8kbJk5SLZ8IIYU=";
    vendorHash = "sha256-qwlZr0LoXZWf72flpORf19PAkHdITY8bxJGkacG2j+A=";
  };

  otelcol-otlp = mkDistribution {
    name = "otelcol-otlp";
    sourceHash = "sha256-W1QHjHMn6xWVN08FpJi2YcKzkpxTPbq9MYIbdQxVHHY=";
    vendorHash = "sha256-gX1D+RPCwcp9UMpzAzEYHDsBrn2KdfN/4RxcgKHViYQ=";
  };
}
