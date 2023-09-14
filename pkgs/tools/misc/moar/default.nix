{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-r1M47KYFJYhLX1HK0uPVkupghyoqdbhStgaquvC4MQI=";
  };

  vendorHash = "sha256-aFCv6VxHD1bOLhCHXhy4ubik8Z9uvU6AeqcMqIZI2Oo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moar.1
  '';

  ldflags = [
    "-s" "-w"
    "-X" "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moar";
    license = licenses.bsd2WithViews;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
