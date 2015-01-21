{stdenv, fetchurl}:

let
  ver = "2014.4.0";
in
stdenv.mkDerivation rec {
  name = "batctl-${ver}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/batman-adv-${ver}/${name}.tar.gz";
    sha256 = "4deae3b6664d0d13acf7a8ece74175a31a72fe58fb15cb9112a9a2014b32cb4c";
  };

  preBuild = ''
    makeFlags=PREFIX=$out
  '';

  meta = {
    homepage = http://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, control tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
