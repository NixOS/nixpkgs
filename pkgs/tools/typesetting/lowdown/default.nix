{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.7.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "2iw5x3lf5knnscp0ifgk50yj48p54cbd34h94qrxa9vdybg2nnipklrqmmqblf6l7qph98h7jvlyr99m5qlrki9lvjr1jcgbgp31pn0";
  };

  nativeBuildInputs = [ which ];

  configurePhase = ''
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                MANDIR=''${!outputBin}/share/man
  '';

  meta = with stdenv.lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}

