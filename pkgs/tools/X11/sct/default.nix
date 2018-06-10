{ stdenv, fetchurl, libX11, libXrandr }:

stdenv.mkDerivation rec {
  name = "sct";

  src = fetchurl {
    url = http://www.tedunangst.com/flak/files/sct.c;
    sha256 = "01f3ndx3s6d2qh2xmbpmhd4962dyh8yp95l87xwrs4plqdz6knhd";
  };

  unpackPhase = "cat ${src} > sct.c";
  patches = [ ./DISPLAY-segfault.patch ];

  buildInputs = [ libX11 libXrandr ];
  buildPhase = "cc sct.c -o sct -lm -lX11 -lXrandr";

  installPhase = "install -Dt $out/bin sct";

  meta = with stdenv.lib; {
    homepage = https://www.tedunangst.com/flak/post/sct-set-color-temperature;
    description = "A minimal utility to set display colour temperature";
    maintainers = [ maintainers.raskin ];
    license = licenses.publicDomain;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
  };
}
