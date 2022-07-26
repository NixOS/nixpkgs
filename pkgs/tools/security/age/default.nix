{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0";
  vendorSha256 = "sha256-Hdsd+epcLFLkeHzJ2CUu4ss1qOd0+lTjhfs9MhI5Weg=";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "sha256-MfyW8Yv8swKqA7Hl45l5Zn4wZrQmE661eHsKIywy36U=";
  };

  ldflags = [
    "-s" "-w" "-X main.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    installManPage doc/*.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
