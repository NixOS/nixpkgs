{ lib, stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.7.9";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "18q8i8lh8w127vzw697n0bzv4mchhna1p4s672hjvy39l3ls8rlj5nwq5npr5fry06yil62sjmq4652vw29r8l49wwk5j82a8l2nr7c";
  };

  nativeBuildInputs = [ which ];

  configurePhase = ''
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                MANDIR=''${!outputBin}/share/man
  '';

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}

