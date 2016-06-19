{ stdenv, lib, pkgconfig, lxc, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lxd-${version}";
  version = "2.0.2";
  rev = "lxd-${version}";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "lxd";
    sha256 = "1rs9g1snjymg6pjz5bj77zk5wbs0w8xmrfxzqs32w6zr1dxhf9hs";
  };

  goDeps = ./deps.json;

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
