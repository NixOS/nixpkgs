{ stdenv, lib, pkgconfig, lxc, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lxd-${version}";
  version = "2.0.0.rc4";
  rev = "lxd-${version}";

  goPackagePath = "github.com/lxc/lxd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "lxd";
    sha256 = "1rpyyj6d38d9kmb47dcmy1x41fiacj384yx01yslsrj2l6qxcdjn";
  };

  goDeps = ./deps.json;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lxc ];

  postInstall = ''
    cp go/src/$goPackagePath/scripts/lxd-images $bin/bin
  '';

  meta = with stdenv.lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = https://github.com/lxc/lxd;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.linux;
  };
}
