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
    hash = "sha256-5AoUgGZEvxbvlksD1P84lxMrHPAP05cN21fABK4UXRg=";
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
    sourceHash = "sha256-4PpZ6anKPkFyVcARJJSEpyy3duTCyrMnnAnh6CWwjUc=";
    vendorHash = "sha256-OoXz9rFIipM0tc6kvkkPdUtYXVIfo0L40V4SUfwSF6M=";
  };

  otelcol-contrib = mkDistribution {
    name = "otelcol-contrib";
    sourceHash = "sha256-wUmpivqLSnRYGTJn3IIlpwFXORmK4FJrc8U472YPV2o=";
    vendorHash = "sha256-7Rb3Ku0q+5cBvgtd/oZaLaFa4chv0b/MzaHEpJvJ6rE=";
    proxyVendor = true; # hash mismatch between linux and darwin
  };

  otelcol-k8s = mkDistribution {
    name = "otelcol-k8s";
    sourceHash = "sha256-yNhE0CwMNus12QDSbP/x9irrIcOdez0e/RpXFFRQ2LE=";
    vendorHash = "sha256-2ZzLCMTafbpmSpkpwvYgkP/Myg/QD1LHgiMigbj3x9I=";
  };

  otelcol-otlp = mkDistribution {
    name = "otelcol-otlp";
    sourceHash = "sha256-+cffC4sOlyPWtydkPZz7M0NF2Q3heQ04/pEB8d+942c=";
    vendorHash = "sha256-WiP+TYj7VZBt3tP4C/ZvQwkDP8/b4F+Bc7Z95p0tBTI=";
  };
}
