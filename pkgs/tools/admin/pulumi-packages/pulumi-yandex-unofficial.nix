{
  lib,
  mkPulumiPackage,
}:
# Note that we are not using https://github.com/pulumi/pulumi-yandex because
# it has been archived in 2022.
mkPulumiPackage rec {
  owner = "Regrau";
  repo = "pulumi-yandex";
  version = "0.98.0";
  rev = "v${version}";
  hash = "sha256-Olwl4JNrJUiJaGha7ZT0Qb0+6hRKxOOy06eKMJfYf0I=";
  vendorHash = "sha256-8mu0msSq59f5GZNo7YIGuNTYealGyEL9kwk0jCcSO68=";
  cmdGen = "pulumi-tfgen-yandex";
  cmdRes = "pulumi-resource-yandex";
  extraLdflags = [
    "-X github.com/regrau/${repo}/provider/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  env.GOWORK = "off";
  meta = with lib; {
    description = "Unofficial Yandex Cloud Resource Provider";
    homepage = "https://github.com/Regrau/pulumi-yandex";
    license = licenses.asl20;
    maintainers = with maintainers; [
      tie
      veehaitch
      trundle
    ];
    mainProgram = cmdRes;
  };
}
