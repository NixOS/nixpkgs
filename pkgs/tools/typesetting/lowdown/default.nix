{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.7.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "3ks1jfw4rjm0qb87ask7wx0xx1grxhbpg53r86q74zhsiqqi6xiza2czg75mydmgic1nr9ny43d5p44sl8ihhja9kwdx230nblx1176";
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

