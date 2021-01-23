{ lib, fetchFromGitHub, buildGoModule }:

with lib;

buildGoModule rec {
  pname = "fcct";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fcct";
    rev = "v${version}";
    sha256 = "0kdsnsp9nzkkfwakcx64md66yz2k7cpw8bkhdv798yirbrqprgp6";
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
