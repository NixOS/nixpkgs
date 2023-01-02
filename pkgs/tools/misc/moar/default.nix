{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j/nxZgaK8WZadYjc7f4nJUn282YfBeflWh7lSjA4QVs=";
  };

  vendorSha256 = "sha256-XexIBg49gK+b2Zef5eR7NfqFZHPp5DXhlcC3Loh6PfI=";

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
