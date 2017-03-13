{ stdenv, fetchurl, pkgconfig, libnl }:

let
  ver = "2017.0";
in
stdenv.mkDerivation rec {
  name = "batctl-${ver}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/batman-adv-${ver}/${name}.tar.gz";
    sha256 = "11n66hcs4jdnfdl896kzz22zlw8d2p8n6sldxfmlc2q7sqki3fy0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = {
    homepage = http://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, control tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
