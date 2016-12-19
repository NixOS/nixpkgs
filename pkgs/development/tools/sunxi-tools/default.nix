{ stdenv, fetchFromGitHub, pkgconfig, libusb }:

stdenv.mkDerivation {
  name = "sunxi-tools-1.3";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "be1b4c7400161b90437432076360c1f99970f54f";
    sha256 = "02pqaaahra4wbv325264qh5i17mxwicmjx9nm33nw2dpmfmg9xhr";
  };

  buildInputs = [ pkgconfig libusb ];

  buildPhase = ''
    make all misc
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin2fex fex2bin phoenix_info sunxi-bootinfo sunxi-fel sunxi-fexc sunxi-nand-part sunxi-pio $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tools for Allwinner A10 devices";
    homepage = http://linux-sunxi.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elitak ];
  };
}
