{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+G3PBYeez1dcUELc4j6CRgxDCDWCxpOfI52QlvMVkrY=";
  };

  vendorSha256 = "sha256-rf0EWMVvuoPUMTQKi/FnUbE2ZAs0C7XosHAzCgwB5wg=";

  ldflags = [
    "-s" "-w"
    "-X github.com/equinix/metal-cli/cmd.Version=${version}"
  ];

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
      $out/bin/metal --version | grep ${version}
  '';

  meta = with lib; {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne nshalman ];
    mainProgram = "metal";
  };
}
