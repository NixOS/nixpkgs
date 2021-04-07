{ lib, fetchFromGitHub, buildGoModule }:

with lib;

buildGoModule rec {
  pname = "fcct";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fcct";
    rev = "v${version}";
    sha256 = "0gxaj2fy889fl5vhb4s89rhih9a65aqjsz2yffhi5z4fa2im8szv";
  };

  vendorSha256 = null;

  doCheck = false;

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
