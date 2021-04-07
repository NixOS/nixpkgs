{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pacparser";
  version = "1.3.7";

  src = fetchurl {
    url = "https://github.com/manugarg/pacparser/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0jfjm8lqyhdy9ny8a8icyd4rhclhfn608cr1i15jml82q8pyqj7b";
  };

  makeFlags = [ "NO_INTERNET=1" ];

  preConfigure = ''
    export makeFlags="$makeFlags PREFIX=$out"
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A library to parse proxy auto-config (PAC) files";
    homepage = "http://pacparser.manugarg.com/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
