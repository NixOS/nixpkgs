{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "darkhttpd";
  version = "1.12";

  src = fetchurl {
    url = "https://unix4lyfe.org/darkhttpd/${pname}-${version}.tar.bz2";
    sha256 = "0185wlyx4iqiwfigp1zvql14zw7gxfacncii3d15yaxk4av1f155";
  };

  enableParallelBuilding = true;

  installPhase = ''
    # install darkhttpd
    install -Dm755 "darkhttpd" "$out/bin/darkhttpd"

    # install license
    install -d "$out/share/licenses/darkhttpd"
    head -n 18 darkhttpd.c > "$out/share/licenses/darkhttpd/LICENSE"
  '';

  meta = with stdenv.lib; {
    description = "Small and secure static webserver";
    homepage    = "https://unix4lyfe.org/darkhttpd/";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms   = platforms.all;
  };
}
