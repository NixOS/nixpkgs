{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hyx-2020.06.09";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/${name}.tar.xz";
    sha256 = "1x8dmll93hrnj24kn5knpwj36y6r1v2ygwynpjwrg2hwd4c1a8hi";
  };

  patches = [ ./no-wall-by-default.patch ];

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = with lib; {
    description = "minimalistic but powerful Linux console hex editor";
    homepage = "https://yx7.cc/code/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
