{ stdenv, fetchurl, pkgconfig, libnl }:

let
  ver = "2018.2";
in
stdenv.mkDerivation rec {
  name = "batctl-${ver}";

  src = fetchurl {
    url = "https://downloads.open-mesh.org/batman/releases/batman-adv-${ver}/${name}.tar.gz";
    sha256 = "09bxh4yifqiphn0ljc3msbxid62ynd9kk3vn82h13gcpfnyckw6z";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = {
    homepage = https://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, control tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
