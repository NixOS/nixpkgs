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
    hash =
      {
        "0.142.0" = "sha256-OwLsf1jBy5K3vKYf0WHUr1ZCzFMSuJPaO79BvN+69G4=";
      }
      .${version};
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
    sourceHash =
      {
        "0.142.0" = "sha256-yJt77K49C1ciu5ab2O4czK/rtjmxhI5JOXJw8N0141w=";
      }
      .${version} or lib.fakeHash;
    vendorHash =
      {
        "0.142.0" = "sha256-k9ZeUrrVXGBjztmNHUnOUyUWc9UDB1byMEmMJte7vcc=";
      }
      .${version} or lib.fakeHash;
  };

  otelcol-contrib = mkDistribution {
    name = "otelcol-contrib";
    sourceHash =
      {
        "0.142.0" = "sha256-J9zWL4N1eAn4H6/TQ+WY9gVBokb2k2NiqIk08X5zIw4=";
      }
      .${version} or lib.fakeHash;
    vendorHash =
      {
        "0.142.0" = "sha256-saw1RLgu2OzJYQsno9mIYknybsFQFUA0dLYRuyZ7BDk=";
      }
      .${version} or lib.fakeHash;
    proxyVendor = true; # hash mismatch between linux and darwin
  };

  otelcol-k8s = mkDistribution {
    name = "otelcol-k8s";
    sourceHash =
      {
        "0.142.0" = "sha256-UZBAoX6h5hFQQuop68nlQAer/zqtUxO2mSlOYkKYses=";
      }
      .${version} or lib.fakeHash;
    vendorHash =
      {
        "0.142.0" = "sha256-zGQyY+1WRUGrpBLJ4vG+x4VhF1+Twce5ku6CqODqlt8=";
      }
      .${version} or lib.fakeHash;
  };

  otelcol-otlp = mkDistribution {
    name = "otelcol-otlp";
    sourceHash =
      {
        "0.142.0" = "sha256-5rYrAPGvS+zSkW/1uDCYGSeDkr1JG6z8h34gvS5uW9Y=";
      }
      .${version} or lib.fakeHash;
    vendorHash =
      {
        "0.142.0" = "sha256-18EihuH7eAlqvwsj8E9ofazH1Kyu1YXwJh/nshokZ+c=";
      }
      .${version} or lib.fakeHash;
  };
}
