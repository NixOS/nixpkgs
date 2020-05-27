{ stdenv, fetchurl, pkgconfig, libnl }:

let cfg = import ./version.nix; in

stdenv.mkDerivation rec {
  pname = "batctl";
  inherit (cfg) version;

  src = fetchurl {
    url = "https://downloads.open-mesh.org/batman/releases/batman-adv-${version}/${pname}-${version}.tar.gz";
    sha256 = cfg.sha256.${pname};
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = {
    homepage = "https://www.open-mesh.org/projects/batman-adv/wiki/Wiki";
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, control tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
