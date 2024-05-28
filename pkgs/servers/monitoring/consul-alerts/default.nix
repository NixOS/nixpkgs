{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "consul-alerts";
  version = "0.6.0";
  rev = "v${version}";

  goPackagePath = "github.com/AcalephStorage/consul-alerts";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "AcalephStorage";
    repo = "consul-alerts";
    sha256 = "0836zicv76sd6ljhbbii1mrzh65pch10w3gfa128iynaviksbgn5";
  };

  meta = with lib; {
    mainProgram = "consul-alerts";
    description = "An extendable open source continuous integration server";
    homepage = "https://github.com/AcalephStorage/consul-alerts";
    # As per README
    platforms = platforms.linux ++ platforms.freebsd ++ platforms.darwin;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nh2 ];
  };
}
