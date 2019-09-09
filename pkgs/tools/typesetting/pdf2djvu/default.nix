{ stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.9.13";
  pname = "pdf2djvu";

  src = fetchurl {
    url = "https://github.com/jwilk/pdf2djvu/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "0qscmfii1pvnb8g7kbl1rdiqyic6ybfiw4kwvy35qqi967c1daz0";
  };

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
