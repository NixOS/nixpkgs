{ stdenv, fetchurl, ncurses, gpgme }:

stdenv.mkDerivation rec {
  name = "gpgstats-${version}";
  version = "0.5";

  src = fetchurl {
    url = "http://www.vanheusden.com/gpgstats/${name}.tgz";
    sha256 = "1n3njqhjwgfllcxs0xmk89dzgirrpfpfzkj71kqyvq97gc1wbcxy";
  };

  buildInputs = [ ncurses gpgme ];

  installPhase = ''
    mkdir -p $out/bin
    cp gpgstats $out/bin
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionals (!stdenv.is64bit)
    [ "-D_FILE_OFFSET_BITS=64" "-DLARGEFILE_SOURCE=1" ];

  meta = with stdenv.lib; {
    description = "Calculates statistics on the keys in your gpg key-ring";
    longDescription = ''
    GPGstats calculates statistics on the keys in your key-ring.
    '';
    homepage = http://www.vanheusden.com/gpgstats/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.unix;
  };
}

