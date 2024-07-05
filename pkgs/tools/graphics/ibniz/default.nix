{ lib, stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "ibniz";
  version = "1.18";

  src = fetchurl {
    url = "http://www.pelulamu.net/ibniz/${pname}-${version}.tar.gz";
    sha256 = "10b4dka8zx7y84m1a58z9j2vly8mz9aw9wn8z9vx9av739j95wp2";
  };

  buildInputs = [ SDL ];

  installPhase = ''
    mkdir -p $out/bin
    cp ibniz $out/bin
  '';

  meta = with lib; {
    description = "Virtual machine designed for extremely compact low-level audiovisual programs";
    homepage = "https://github.com/viznut/IBNIZ";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
    mainProgram = "ibniz";
  };
}
