{ lib
, pkgs
, go
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ocb";
  version = "0.85.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector";
    rev = "cmd/builder/v${version}";
    hash = "sha256-mHuno6meQLWtzP8hGXK37O8SbIyeh3vEvMwwKFM624s=";
    fetchSubmodules = true;
  };

  modRoot = "cmd/builder";
  vendorHash = "sha256-ZLARDZltb7ZPt4iLzHkhUesCqGPD88uEJMkeGzVf7Rc=";

  nativeBuildInputs = with pkgs; [
    gnumake
  ];

  buildPhase = ''
    runHook preBuild

    make ocb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ../../bin/ocb_${go.GOOS}_${go.GOARCH} $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector/tree/main/cmd/builder";
    changelog = "https://github.com/open-telemetry/opentelemetry-collector/blob/${src.rev}/CHANGELOG.md";
    description = "OpenTelemetry Collector Builder (ocb)";
    longDescription = ''
      This program generates a custom OpenTelemetry Collector binary based on a given configuration.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "ocb";
  };
}
