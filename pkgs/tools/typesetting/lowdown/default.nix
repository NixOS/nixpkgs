{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.8.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "28kwj053lm3510cq7pg4rqx6linv5zphhm2h6r9icigclfq7j9ybnd7vqbn2v4ay0r8ghac5cjbqab5zy8cjlgllwhwsxg0dnk75x2i";
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

