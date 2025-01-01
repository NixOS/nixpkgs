{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
  version = "11.33.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    rev = "refs/tags/v${version}";
    hash = "sha256-zMv2Um8pw5unoy6h2aApDLGWy2SSJjkD2bbqYi1AxKU=";
  };

  proxyVendor = true;

  vendorHash = "sha256-n9PdtuKHm6gqVudf49PakK6fChHZfiGYr9eTPkSBfV8=";

  subPackages = [ "apps/cnspec" ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${version}"
  ];

  meta = with lib; {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      fab
      mariuskimmina
    ];
  };
}
