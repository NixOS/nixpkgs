{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "darkhttpd-${version}";
  version = "1.12";

  src = fetchurl {
    url = "https://unix4lyfe.org/darkhttpd/${name}.tar.bz2";
    sha256 = "0185wlyx4iqiwfigp1zvql14zw7gxfacncii3d15yaxk4av1f155";
  };

  installPhase = ''
    install -d "$out/bin"

    # install darkhttpd
    install -Dm755 "darkhttpd" "$out/bin/darkhttpd"

    # install license
    install -d "$out/share/licenses/darkhttpd"
    head -n 18 darkhttpd.c > "$out/share/licenses/darkhttpd/LICENSE"
  '';

  meta = with stdenv.lib; {
    description = "Small and secure static webserver";
    homepage = http://dmr.ath.cx/net/darkhttpd/;
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
