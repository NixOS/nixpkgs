{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "darkhttpd";
  version = "1.12";

  src = fetchurl {
    url = "https://unix4lyfe.org/darkhttpd/${pname}-${version}.tar.bz2";
    sha256 = "0185wlyx4iqiwfigp1zvql14zw7gxfacncii3d15yaxk4av1f155";
  };

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm555 -t $out/bin darkhttpd
    install -Dm444 -t $out/share/doc/${pname} README
    head -n 18 darkhttpd.c > $out/share/doc/${pname}/LICENSE
  '';

  meta = with lib; {
    description = "Small and secure static webserver";
    homepage = "https://unix4lyfe.org/darkhttpd/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.all;
  };
}
