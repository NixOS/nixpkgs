{ stdenv, lib, pkgconfig, lxc, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lxd-${version}";
  version = "2.14";
  rev = "lxd-${version}";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "lxd";
    sha256 = "1jy60lb2m0497bnjj09qvflsj2rb0jjmlb8pm1xn5g4lpzibszjm";
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
