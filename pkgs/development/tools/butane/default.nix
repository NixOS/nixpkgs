{ lib, fetchFromGitHub, buildGoModule }:

with lib;

buildGoModule rec {
  pname = "butane";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "butane";
    rev = "v${version}";
    sha256 = "sha256-tLUC/1yD3vgId98UWiZOlud38uO+CUzp0uuYKkAXJEs=";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "internal" ];

  ldflags = [
    "-X github.com/coreos/butane/internal/version.Raw=v${version}"
  ];

  postInstall = ''
    mv $out/bin/{internal,butane}
  '';

  meta = {
    description = "Translates human-readable Butane configs into machine-readable Ignition configs";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/butane";
    maintainers = with maintainers; [ elijahcaine ruuda ];
    platforms = platforms.unix;
  };
}
