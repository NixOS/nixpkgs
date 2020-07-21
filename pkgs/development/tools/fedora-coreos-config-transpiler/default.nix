{ lib, fetchFromGitHub, buildGoModule }:

with lib;

buildGoModule rec {
  pname = "fcct";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fcct";
    rev = "v${version}";
    sha256 = "18hmnip1s0smp58q500p8dfbrmi4i3nsyq22ri5cs53wbvz3ih1l";
  };

  vendorSha256 = null;

  subPackages = [ "internal" ];

  buildFlagsArray = ''
    -ldflags=-X github.com/coreos/fcct/internal/version.Raw=v${version}
  '';

  postInstall = ''
    mv $out/bin/{internal,fcct}
  '';

  meta = {
    description = "Translates Fedora CoreOS configs into Ignition configs";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/fcct";
    maintainers = with maintainers; [ elijahcaine ruuda ];
    platforms = platforms.unix;
  };
}
