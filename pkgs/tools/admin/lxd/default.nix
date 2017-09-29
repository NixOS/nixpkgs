{ stdenv, lib, pkgconfig, lxc, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lxd-${version}";
  version = "2.16";
  rev = "lxd-${version}";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "lxd";
    sha256 = "0i2mq9m8k9kznwz1i0xb48plp1ffpzvbdrvqvagis4sm17yab3fn";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lxc ];

  meta = with stdenv.lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = https://linuxcontainers.org/lxd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.linux;
  };
}
