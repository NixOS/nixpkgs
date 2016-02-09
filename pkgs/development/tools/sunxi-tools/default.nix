{ stdenv, fetchgit, pkgconfig, libusb }:
stdenv.mkDerivation {
  name = "sunxi-tools-1.3";

  src = fetchgit {
    url = "https://github.com/linux-sunxi/sunxi-tools";
    rev = "be1b4c7400161b90437432076360c1f99970f54f";
    sha256 = "0qbl4v66a3mvqai29q2y60zf2b5lj32mh9gyn44gfp0w2bsb10yj";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ elitak ];
  };
}
