{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
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

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-Ov0TPoMm0qi7kkWUUni677sCP1LwkT9+n3KHcAlQkDA=";
  subPackages = [ "cmd/influx" ];

  ldflags = [
    "-X main.commit=v${version}"
    "-X main.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd influx \
      --bash <($out/bin/influx completion bash) \
      --zsh  <($out/bin/influx completion zsh)
  '';

  meta = with lib; {
    description = "CLI for managing resources in InfluxDB v2";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = [ ];
    mainProgram = "influx";
  };
}
