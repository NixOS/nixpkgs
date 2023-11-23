{ lib, stdenv, ocaml, makeWrapper, fetchsvn, ghostscript, imagemagick, perl, poppler_utils, tesseract, unpaper }:

stdenv.mkDerivation {
  version = "0.1.7";
  pname = "pdfsandwich";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/pdfsandwich/code/trunk/src";
    rev = "75";
    sha256 = "1420c33divch087xrr61lvyf975bapqkgjqaighl581i69nlzsm6";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ocaml perl ];
  installPhase = ''
    mkdir -p $out/bin
    cp -p pdfsandwich $out/bin
    wrapProgram $out/bin/pdfsandwich --prefix PATH : ${lib.makeBinPath [ imagemagick ghostscript poppler_utils unpaper tesseract ]}

    mkdir -p $out/man/man1
    cp -p pdfsandwich.1.gz $out/man/man1
  '';

meta = with lib; {
    description = "OCR tool for scanned PDFs";
    homepage = "http://www.tobias-elze.de/pdfsandwich/";
    license = licenses.gpl2;
    maintainers = [ maintainers.rps ];
    platforms = platforms.linux;
    mainProgram = "pdfsandwich";
  };
}
