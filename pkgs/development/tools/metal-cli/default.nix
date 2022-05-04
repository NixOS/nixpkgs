{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-muhHBUb5Ttj4n6fJzIJMqics5rKupeSBZAd4JxZUe64=";
  };

  vendorSha256 = "sha256-F8d5i9jvjY11Pv6w0ZXI3jr0Wix++B/w9oRTuJGpQfE=";

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
