{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-bindata-assetfs-${version}";
  version = "20160814-${rev}";
  rev = "e1a2a7e";
  goPackagePath = "github.com/elazarl/go-bindata-assetfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "elazarl";
    repo = "go-bindata-assetfs";
    sha256 = "0b6q8h9fwpgpkvml1j87wq9174g7px1dmskhm884drpvswda2djk";
  };

  meta = with stdenv.lib; {
    description = "Serve embedded files from jteeuwen/go-bindata";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ avnik ];
  };
}
