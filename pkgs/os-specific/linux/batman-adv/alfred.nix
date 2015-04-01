{ stdenv, fetchurl, pkgconfig, gpsd }:

let
  ver = "2014.4.0";
in
stdenv.mkDerivation rec {
  name = "alfred-${ver}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/batman-adv-${ver}/${name}.tar.gz";
    sha256 = "99e6c64e7069b0b7cb861369d5c198bfc7d74d41509b8edd8a17ba78e7c8d034";
  };

  buildInputs = [ pkgconfig gpsd ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = {
    homepage = http://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, information distribution tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
