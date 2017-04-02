{ stdenv, fetchurl, pkgconfig, gpsd, libcap, libnl }:

let
  ver = "2017.0";
in
stdenv.mkDerivation rec {
  name = "alfred-${ver}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/batman-adv-${ver}/${name}.tar.gz";
    sha256 = "1a0gnl8v8l7zj01hca0srbsc11sk51rj1qac6lw242z35hyximpq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpsd libcap libnl ];

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
