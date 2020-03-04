{ stdenv, fetchurl, fetchpatch, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.9.14";
  pname = "pdf2djvu";

  src = fetchurl {
    url = "https://github.com/jwilk/pdf2djvu/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "05z2bbg54pfsi668fwcjrcr5iz9llf9gprzdsrn6fw5wjv4876zi";
  };

  patches = [
    # fix build with Poppler 0.83
    (fetchpatch {
      url = "https://github.com/jwilk/pdf2djvu/commit/0aa17bb79dbcdfc249e4841f5b5398e27cfdfd41.patch";
      sha256 = "0mr14nz5w7z4ri2556bxkf3cnn2f7dhwsld7csrh6z5qqb7d5805";
    })
    (fetchpatch {
      url = "https://github.com/jwilk/pdf2djvu/commit/27b9e028091a2f370367e9eaf37b4bb1cde87b62.patch";
      sha256 = "03apsg1487jl800q8j70hicvg6xsndd593bg7babm4vgivkxb0da";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ djvulibre poppler fontconfig libjpeg ];

  preConfigure = ''
    sed -i 's#\$djvulibre_bin_path#${djvulibre.bin}/bin#g' configure

    # Configure skips the failing check for usability of windres when it is nonempty.
    unset WINDRES
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Creates djvu files from PDF files";
    homepage = https://jwilk.net/software/pdf2djvu;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    inherit version;
  };
}
