{ stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.9.9";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/pdf2djvu/releases/download/${version}/${name}.tar.xz";
    sha256 = "0v1his9ph04dllzyxkirc8kd23l41qc41bwg9bfsbzkri16b7xik";
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
