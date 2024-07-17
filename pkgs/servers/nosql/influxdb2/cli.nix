{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

let
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influx-cli";
    rev = "v${version}";
    sha256 = "sha256-0Gyoy9T5pA+40k8kKybWBMtOfpKZxw3Vvp4ZB4ptcJs=";
  };

in
buildGoModule {
  pname = "influx-cli";
  version = version;
  inherit src;

  vendorHash = "sha256-Ov0TPoMm0qi7kkWUUni677sCP1LwkT9+n3KHcAlQkDA=";
  subPackages = [ "cmd/influx" ];

  ldflags = [
    "-X main.commit=v${version}"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "influx";
  };
}
