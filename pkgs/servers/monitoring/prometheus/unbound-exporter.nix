{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  version = "0.4.6";
in
buildGoModule {
  pname = "unbound_exporter";
  inherit version;

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "unbound_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-p2VSIQXTnNGgqUSvWQ4J3SbrnWGBO21ps4VCWOjioLM=";
  };

  vendorHash = "sha256-q3JqAGeEU5WZWTzdFE9hR2dAnsFjMM44JiYdodZrnhs=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) unbound;
  };

  meta = with lib; {
    changelog = "https://github.com/letsencrypt/unbound_exporter/releases/tag/v${version}";
    description = "Prometheus exporter for Unbound DNS resolver";
    mainProgram = "unbound_exporter";
    homepage = "https://github.com/letsencrypt/unbound_exporter/tree/main";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
