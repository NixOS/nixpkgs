{ stdenv, lib, pkgconfig, lxc, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lxd-${version}";
  version = "2.12";
  rev = "lxd-${version}";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "lxd";
    sha256 = "1znqsf6iky21kddvl13bf0lsj65czabwysdbvha24lm16s51mv0p";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lxc ];

  meta = with stdenv.lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = https://github.com/lxc/lxd;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.linux;
  };
}
