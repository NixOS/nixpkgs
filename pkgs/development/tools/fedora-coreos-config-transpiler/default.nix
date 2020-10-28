{ lib, fetchFromGitHub, buildGoModule }:

with lib;

buildGoModule rec {
  pname = "fcct";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fcct";
    rev = "v${version}";
    sha256 = "1ffjn0l38szpkgd11mfaiynf9n8ljndv122l8amwiwp5mrh3hsl6";
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
