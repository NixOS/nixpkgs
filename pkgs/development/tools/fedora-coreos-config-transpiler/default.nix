{ lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  pname = "fcct";
  version = "0.6.0";

  goPackagePath = "github.com/coreos/fcct";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fcct";
    rev = "v${version}";
    sha256 = "18hmnip1s0smp58q500p8dfbrmi4i3nsyq22ri5cs53wbvz3ih1l";
  };

  buildFlagsArray = ''
    -ldflags=-X ${goPackagePath}/internal/version.Raw=v${version}
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

