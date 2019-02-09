{ stdenv, fetchurl, pkgconfig, gpsd, libcap, libnl }:

let
  ver = "2019.0";
in
stdenv.mkDerivation rec {
  name = "alfred-${ver}";

  src = fetchurl {
    url = "https://downloads.open-mesh.org/batman/releases/batman-adv-${ver}/${name}.tar.gz";
    sha256 = "0sml6z90kpchmn61597j7yag97gk59fscz4xjxdfh9zycd3nfsn0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpsd libcap libnl ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = {
    homepage = https://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, information distribution tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
