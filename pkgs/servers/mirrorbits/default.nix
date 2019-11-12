{ lib, buildGoPackage, fetchFromGitHub, fetchpatch
, pkgconfig, zlib, geoip }:

buildGoPackage rec {
  pname = "mirrorbits";
  version = "0.4";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "etix";
    repo = "mirrorbits";
    sha256 = "11f9wczajba147qk5j73pxjrvlxkgr598sjvgjn2b8nxm49g2pan";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/etix/mirrorbits/commit/03a4e02214bdb7bb60240ddf25b887ccac5fb118.patch";
      sha256 = "08332cfxmp2nsfdj2ymg3lxkav8h44f6cf2h6g9jkn03mkliblm5";
    })
  ];

  postPatch = ''
    rm -rf testing
  '';

  # Fix build with go >=1.12
  preBuild = ''
    sed -i s/"_Ctype_struct_GeoIPRecordTag"/"C.struct_GeoIPRecordTag"/ ./go/src/github.com/etix/geoip/geoip.go
  '';

  goPackagePath = "github.com/etix/mirrorbits";
  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib geoip ];

  meta = {
    description = "geographical download redirector for distributing files efficiently across a set of mirrors";
    homepage = "https://github.com/etix/mirrorbits";
    longDescription = ''
      Mirrorbits is a geographical download redirector written in Go for
      distributing files efficiently across a set of mirrors. It offers
      a simple and economic way to create a Content Delivery Network
      layer using a pure software stack. It is primarily designed for
      the distribution of large-scale Open-Source projects with a lot
      of traffic.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.unix;
  };
}
