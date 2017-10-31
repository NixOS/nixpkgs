{ stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.9.7";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/pdf2djvu/releases/download/${version}/${name}.tar.xz";
    sha256 = "1h92f9prx69wz9h57lncxj8ddh2xg6q7hjhlqqzzf30k59il4zcy";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ djvulibre poppler fontconfig libjpeg ];

  preConfigure = ''
    sed -i 's#\$djvulibre_bin_path#${djvulibre.bin}/bin#g' configure
  '';

  meta = with stdenv.lib; {
    description = "Creates djvu files from PDF files";
    homepage = https://jwilk.net/software/pdf2djvu;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    inherit version;
  };
}
