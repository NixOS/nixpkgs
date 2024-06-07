{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "ctmg";
  version = "1.2";

  src = fetchzip {
    url = "https://git.zx2c4.com/ctmg/snapshot/ctmg-${version}.tar.xz";
    sha256 = "1i4v8sriwjrmj3yizbl1ysckb711yl9qsn9x45jq0ij1apsydhyc";
  };

  installPhase = "install -D ctmg.sh $out/bin/ctmg";

  meta = with lib; {
    description = "Encrypted container manager for Linux using cryptsetup";
    homepage = "https://git.zx2c4.com/ctmg/about/";
    license = licenses.isc;
    maintainers = with maintainers; [ mrVanDalo ];
    platforms = platforms.linux;
    mainProgram = "ctmg";
  };
}
