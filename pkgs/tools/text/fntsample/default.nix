{ lib, stdenv, fetchurl, fetchFromGitHub, cmake, pkg-config
, cairo, fontconfig, freetype, glib, pango
, makeWrapper, perlPackages
}:

stdenv.mkDerivation rec {
  pname = "fntsample";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "eugmes";
    repo = pname;
    rev = "release/${version}";
    sha256 = "0pcqqdriv6hq64zrqd9vhdd9p2vhimjnajcxdz10qnqgrkmm751v";
  };

  blocks = fetchurl {
    url = "https://www.unicode.org/Public/13.0.0/ucd/Blocks.txt";
    sha256 = "17y1sr17jvjpgvmv15dc9kfazabkrpga3mw8yl99q6ngkxm2pa41";
  };

  cmakeFlags = [
    "-DUNICODE_BLOCKS=${blocks.outPath}"
  ];

  outputs = [ "out" "man" ];
  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [ cairo fontconfig freetype glib pango perlPackages.perl ];

  postFixup = ''
    for cmd in pdfoutline pdf-extract-outline; do
      wrapProgram "$out/bin/$cmd" \
        --prefix PERL5LIB : "${perlPackages.makePerlPath (
          with perlPackages; [
            PDFAPI2
            libintlperl
            ListMoreUtils
            ExporterTiny
          ]
        )}"
    done
  '';

  meta = with lib; {
    description = "PDF and PostScript font samples generator";
    homepage = "https://github.com/eugmes/fntsample";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aegyo ];
    platforms = platforms.unix;
  };
}
