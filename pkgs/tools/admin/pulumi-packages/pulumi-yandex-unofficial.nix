{
  lib,
  mkPulumiPackage,
}:
# Note that we are not using https://github.com/pulumi/pulumi-yandex because
# it has been archived in 2022.
mkPulumiPackage rec {
  owner = "Regrau";
  repo = "pulumi-yandex";
  version = "0.99.1";
  rev = "v${version}";
  hash = "sha256-LCWrt5TIvzXssLjV523K27LWzd+za88WLzgbLLnK+sw=";
  vendorHash = "sha256-z9UAGX3PRInlO8v/1zgPYR8SlTnDuZfgEruBWJfVNiU=";
  cmdGen = "pulumi-tfgen-yandex";
  cmdRes = "pulumi-resource-yandex";
  extraLdflags = [
    "-X=github.com/regrau/${repo}/provider/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  env.GOWORK = "off";
  meta = with lib; {
    description = "Unofficial Yandex Cloud Resource Provider";
    mainProgram = "pulumi-resource-yandex";
    homepage = "https://github.com/Regrau/pulumi-yandex";
    license = licenses.asl20;
    maintainers = with maintainers; [
      tie
      veehaitch
      trundle
    ];
  };
}
