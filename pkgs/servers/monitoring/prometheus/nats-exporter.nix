{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2+nkWwa5n7DyVitnJ8gt7b72Y6XiiLM7ddTM2Cp9/LQ=";
  };

  vendorSha256 = "sha256-bsk6htRnb4NiaJXTHNjPGN9NEy8owRJujancK3nVIsA=";

  meta = with lib; {
    description = "Exporter for NATS metrics";
    homepage = "https://github.com/nats-io/prometheus-nats-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
