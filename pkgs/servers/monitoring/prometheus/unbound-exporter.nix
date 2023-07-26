{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

let
  version = "0.4.4";
in
buildGoModule {
  pname = "unbound_exporter";
  inherit version;

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "unbound_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-0eo56z5b+hzKCY5OKg/9F7rjLyoSKPJoHLoXeMjCuFU=";
  };

  vendorHash = "sha256-4aWuf9UTPQseEwDJfWIcQW4uGMffRnWlHhiu0yMz4vk=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) unbound;
  };

  meta = with lib; {
    changelog = "https://github.com/letsencrypt/unbound_exporter/releases/tag/v${version}";
    description = "Prometheus exporter for Unbound DNS resolver";
    homepage = "https://github.com/letsencrypt/unbound_exporter/tree/main";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
